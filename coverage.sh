#!/bin/sh
#
# Generate test coverage statistics for Go packages.
#

set -e

output() {
  printf "\033[32m"
  echo $1
  printf "\033[0m"

  if [ "$2" = 1 ]; then
    exit 1
  fi
}

workdir=".cover"
cover_mode="set"
coverage_report="$workdir/coverage.txt"
coverage_xml_report="$workdir/coverage.xml"
junit_report="$workdir/junit.txt"
junit_xml_report="$workdir/report.xml"
lint_report="$workdir/lint.txt"
vet_report="$workdir/vet.txt"
cloc_report="$workdir/cloc.xml"
packages=$(go list ./... | grep -v vendor)

test -d $workdir || mkdir -p $workdir

show_help() {
cat << EOF
Generate test coverage statistics for Go packages.

  -- Command Flag --
  -h | --help                    Display this help and exit
  -m | --mode                    Set coverage mode. (set|count|atomic)

  -- Command Action --
  tool                           Install go dependency tools like gocov or golint.
  testing                        Run go testing for all packages
  coverage                       Generate coverage report for all packages
  junit                          Generate coverage xml report for junit plugin
  lint                           Generate Lint report for all packages
  vet                            Generate Vet report for all packages
  cloc                           Generate Count Lines of Code report for all files
  all                            Execute coverage、junit、lint、vet and cloc report

Contribute and source at https://github.com/appleboy/golang-testing
EOF
exit 0
}

install_dependency_tool() {
  go get -u github.com/jstemmer/go-junit-report
  go get -u github.com/axw/gocov/gocov
  go get -u github.com/AlekSi/gocov-xml
  go get -u github.com/golang/lint/golint
  curl https://raw.githubusercontent.com/AlDanial/cloc/master/cloc -o /usr/bin/cloc
  chmod 755 /usr/bin/cloc
}

testing() {
  test -f ${junit_report} && rm -f ${junit_report}
  output "Running ${cover_mode} mode for coverage."
  for pkg in $packages; do
    f="$workdir/$(echo $pkg | tr / -).cover"
    output "Testing coverage report for ${pkg}"
    go test -v -cover -coverprofile=${f} -covermode=${cover_mode} $pkg | tee -a ${junit_report}
  done

  output "Convert all packages coverage report to $coverage_report"
  echo "mode: $cover_mode" > "$coverage_report"
  grep -h -v "^mode:" "$workdir"/*.cover >> "$coverage_report"
}

generate_cover_report() {
  gocov convert ${coverage_report} | gocov-xml > ${coverage_xml_report}
}

generate_junit_report() {
  cat $junit_report | go-junit-report > ${junit_xml_report}
}

generate_lint_report() {
  for pkg in $packages; do
    output "Go Lint report for ${pkg}"
    golint ${pkg} | tee -a ${lint_report}
  done
}

generate_vet_report() {
  for pkg in $packages; do
    output "Go Vet report for ${pkg}"
    go vet -n -x ${pkg} | tee -a ${vet_report}
  done
}

generate_cloc_report() {
  cloc --by-file --xml --out=${cloc_report} --exclude-dir=vendor,Godeps,.cover .
}

# Process command line...

[ $# -gt 0 ] || show_help

while [ $# -gt 0 ]; do
  case $1 in
    --help | -h)
      show_help
    ;;
    --mode | -m)
      shift
      cover_mode=$1
      test -z $cover_mode && show_help
      shift
      ;;
    tool)
      install_dependency_tool
      shift
      ;;
    testing)
      testing
      shift
      ;;
    coverage)
      generate_cover_report
      shift
      ;;
    junit)
      generate_junit_report
      shift
      ;;
    lint)
      generate_lint_report
      shift
      ;;
    vet)
      generate_vet_report
      shift
      ;;
    cloc)
      generate_cloc_report
      shift
      ;;
    all)
      testing
      generate_cover_report
      generate_junit_report
      generate_lint_report
      generate_vet_report
      generate_cloc_report
      shift
      ;;
    *)
      show_help ;;
  esac
done
