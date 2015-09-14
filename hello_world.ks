print "Commence countdown...".
from { local countdown is 10 } until countdown = 0 step { set countdown to countdown - 1 } do {
  print "..." + countdown.
  wait 1.
}

print "Ignition. We are go for liftoff."
lock throttle to 1.0.
wait 0.5.
until ship:maxthrus > 0 {
  wait 0.5.
  print "Stage activiated.".
  stage.
}

wait until ship:apoapsis > 70000.
