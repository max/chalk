workflow "build and test" {
  on = "push"
  resolves = "after success"
}

action "build" {
  uses = "actions/npm@master"
  args = ["install"]
}

action "test" {
  needs = ["build"]
  uses = "actions/npm@master"
  args = ["test"]
}

action "after success" {
  needs = ["test"]
  uses = "docker://alpine"
  runs = ["sh", "-c", "./node_modules/.bin/nyc report --reporter=text-lcov | ./node_modules/.bin/coveralls"]
}
