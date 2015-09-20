print "Ignition. We are go for liftoff.".
lock throttle to 0.7.
set desired_dir to 90.
lock steering to heading(desired_dir, 90).
wait 0.5.
stage.

wait until ship:altitude > 1000.
print "Beginning gravity turn...".
set t to 0.
until ship:apoapsis > 70000 {
  set desired_eta_factor to 1 - (25000 - ship:altitude) / 25000.
  if desired_eta_factor > 1 { set desired_eta_factor to 1. }.
  set desired_eta to 8 + 32 * desired_eta_factor.
  set t to chase_ap(desired_eta, t).
  wait 0.1.
}
print "Suborbital trajector achieved".
lock throttle to 0.0.

wait until eta:apoapsis < 10.
print "Approaching apoapsis".
lock steering to heading(desired_dir, 0).

wait until eta:apoapsis < 1.
print "Burning final fuel".
lock throttle to 1.0.

wait until stage:liquidfuel < 0.01 or ship:periapsis > 30000.
print "Disconnecting engine stage".
wait 1.
stage.
unlock steering.

wait until alt:radar < 40000.
print "Pointing ship for landing.".
set vs to velocity:surface.
lock steering to R(0,0,0) * V( 0-vs:x, 0-vs:y, 0-vs:z ).
TOGGLE SAS.
wait 5.
unlock steering.
wait until alt:radar < 5000.
print "Deploying chute.".
stage.

function chase_ap {
  parameter desired_eta.
  parameter last_dt.
  set current_eta to eta:apoapsis.

  print "Chasing ETA of " + round(desired_eta, 2).
  print "Current ETA: " + round(eta:apoapsis, 2).
  set dt to current_eta - desired_eta.
  if dt > 0 {
    if dt > last_dt {
      gravturn(90, dt / 2).
      wait 2.
    }.
  }.

  return dt.
}

function gravturn {
  parameter dir.
  parameter amt.

  set pitch to 90 - vectorangle(UP:FOREVECTOR, FACING:FOREVECTOR).
  set atmo to 30000.
  set atmo_max to constant():e ^ (ship:altitude / 15000).
  print "Desired pitch change is " + round(amt, 3).
  print "Max pitch change is " + round(atmo_max, 3).
  if amt > atmo_max {
    print "Limiting pitch change to " + round(atmo_max, 3).
    set amt to atmo_max.
  }
  set new_pitch to pitch - amt.

  if new_pitch < 0 {
    print "Reached horizon. Limiting pitch to 0.".
    set new_pitch to 0.
  }.

  print "Turning to " + round(dir, 2) + " mark " + round(new_pitch, 2).
  gradual_turn(dir, new_pitch, 1).
}

function gradual_turn {
  parameter new_dir.
  parameter new_pitch.
  parameter turn_speed.

  set pitch to 90 - vectorangle(UP:FOREVECTOR, FACING:FOREVECTOR).
  if (ship:altitude < 20000) {
    set turn_speed to turn_speed * 3.
  } else {
    set turn_speed to turn_speed / 5.
  }.
  set dp to (pitch - new_pitch) / turn_speed.
  set x to turn_speed.

  until x <= 0 {
    set int_pitch to pitch - dp * (turn_speed - x).
    lock steering to heading(new_dir, int_pitch).
    set x to x - 0.1.
    wait 0.1.
  }
}

// print "Pointing ship for landing.".
// set vs to velocity:surface.
// lock steering to R(0,0,0) * V( 0-vs:x, 0-vs:y, 0-vs:z ).
// wait 2.
// print "Staging.".
// stage.
// wait until alt:radar < 5000.
// print "Deploying chute.".
// stage.
