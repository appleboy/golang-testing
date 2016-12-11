#!/bin/bash
#
# Generate test coverage statistics for Go packages.
#

set -e

output() {
  color="32"
  if [[ "$2" -gt 0 ]]; then
    color="31"
  fi
  printf "\033[${color}m"
  echo $1
  printf "\033[0m"
}

workdir=".cover"
cover_mode="set"
kernel_name=$(uname -s)
packages=$(go list ./... | grep -v vendor)

show_help() {
cat << EOF
Generate test coverage statistics for Go packages.

  -- Command Flag --
  -h | --help                    Display this help and exit
  -m | --mode                    Set coverage mode. default is "set" (set|count|atomic)
  -d | --dir                     Set store coverage folder (default is ".cover")

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

# add this function on your .bashrc file to echoed Go version
go_version() {
  if [ "$1" = "" ]; then
    match=1
  else
    match=2
  fi
  version=$(go version)
  regex="go(([0-9].[0-9]).[0-9])"
  if [[ $version =~ $regex ]]; then
    echo ${BASH_REMATCH[${match}]}
  fi
}

set_workdir() {
  workdir=$1
  test -d $workdir || mkdir -p $workdir
  coverage_report="$workdir/coverage.txt"
  coverage_xml_report="$workdir/coverage.xml"
  junit_report="$workdir/junit.txt"
  junit_xml_report="$workdir/report.xml"
  lint_report="$workdir/lint.txt"
  vet_report="$workdir/vet.txt"
  cloc_report="$workdir/cloc.xml"
}

install_dependency_tool() {
  goversion=$(go_version "gloabl")
  [ -d "${GOPATH}/bin" ] || mkdir -p ${GOPATH}/bin
  go get -u github.com/jstemmer/go-junit-report
  go get -u github.com/axw/gocov/gocov
  go get -u github.com/AlekSi/gocov-xml
  if [[ "$goversion" < "1.6" ]]; then
    output "Golint requires Go 1.6 or later."
  else
    go get -u github.com/golang/lint/golint
  fi
  curl https://raw.githubusercontent.com/AlDanial/cloc/master/cloc -o ${GOPATH}/bin/cloc
  chmod 755 ${GOPATH}/bin/cloc
}

errorNumber() {
  if [ "$1" -ne 0 ]; then
    error=$1
  fi
}

testing() {
  error=0
  test -f ${junit_report} && rm -f ${junit_report}
  output "Running ${cover_mode} mode for coverage."
  for pkg in $packages; do
    f="$workdir/$(echo $pkg | tr / -).cover"
    output "Testing coverage report for ${pkg}"
    go test -v -cover -coverprofile=${f} -covermode=${cover_mode} $pkg | tee -a ${junit_report}
    # ref: http://stackoverflow.com/questions/1221833/bash-pipe-output-and-capture-exit-status
    errorNumber ${PIPESTATUS[0]}
  done

  output "Convert all packages coverage report to $coverage_report"
  echo "mode: $cover_mode" > "$coverage_report"
  grep -h -v "^mode:" "$workdir"/*.cover >> "$coverage_report"
  if [ "$error" -ne 0 ]; then
    output "Get Tesing Error Number Code: ${error}" ${error}
  fi
}

generate_cover_report() {
  gocov convert ${coverage_report} | gocov-xml > ${coverage_xml_report}
}

generate_junit_report() {
  cat ${junit_report} | go-junit-report > ${junit_xml_report}
}

generate_lint_report() {
  for pkg in $packages; do
    output "Go Lint report for ${pkg}"
    golint ${pkg} | tee -a ${lint_report}
  done

  # fix path error
  root_path=${PWD//\//\\/}
  [ "$kernel_name" == "Darwin" ] && sed -e "s/${root_path}\(\/\)*//g" -i '' ${lint_report}
  [ "$kernel_name" == "Linux" ] && sed -e "s/${root_path}\(\/\)*//g" -i ${lint_report}
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

# set default folder.
set_workdir $workdir

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
      test -z ${cover_mode} && show_help
      shift
      test -z $1 && show_help
      ;;
    --dir | -d)
      shift
      workdir=$1
      test -z ${workdir} && show_help
      set_workdir ${workdir}
      shift
      test -z $1 && show_help
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

if [[ "$error" -gt 0 ]]; then
  exit $error
fi
