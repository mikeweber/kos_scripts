deorbit(30000).

function deorbit {
  parameter desired_pe.

  set vs to velocity:orbit.
  print "Pointing to retrograde...".
  lock steering to R(0,0,0) * V(0-vs:x, 0-vs:y, 0-vs:z).
  wait 10.
  toggle sas.
  unlock steering.
  lock throttle to 0.5.
  print "Commence de-orbit burn...".
  wait until ship:periapsis < desired_pe.
  print "De-orbit burn complete. Periapsis set to " + desired_pe.
  lock throttle to 0.
  prepare_for_landging().
}

function prepare_for_landging {
  wait until alt:radar < 40000.	
  print "Pointing ship for landing.".
  set vs to velocity:surface.
  lock steering to R(0,0,0) * V( 0-vs:x, 0-vs:y, 0-vs:z ).
  TOGGLE SAS.
  wait 5.
  unlock steering.
  wait until velocity:surface < 250.
  print "Deploying chute.".
  toggle sas.
  stage.
}
