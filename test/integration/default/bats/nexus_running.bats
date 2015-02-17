#!/usr/bin/env bats

@test "nexus is reachable locally" {
  run wget localhost:8081/nexus
  [ "$status" -eq 0 ]
}
