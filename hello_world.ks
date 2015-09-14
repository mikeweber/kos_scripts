print "Commence countdown...".
from { local countdown is 10. } until countdown = 0 step { set countdown to countdown - 1. } do {
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

print "Beginning gravity turn...".
wait until ship:altitude > 10000.
lock steering to heading(90, 80).
wait until eta:apoapsis > 40.
print "Turning to 70*".
lock steering to heading(90, 70).
wait 4.
wait until eta:apoapsis > 40.
print "Turning to 60*".
lock steering to heading(90, 60).
wait 4.
wait until eta:apoapsis > 40.
print "Turning to 45*".
lock steering to heading(90, 45).
wait until ship:apoapsis > 70000.
print "Suborbital acheived".
lock throttle 0.0.
print "Pointing ship for landing."
set vs to velocity:surface.
lock steering to R(0,0,0) * V( 0-vs;x, 0-vs:y, 0-vs:z ).
wait 2.
print "Staging."
stage.

