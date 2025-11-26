#!mainFile "../dev_main.opy"

# subroutine startFiring

# Macro function for retrieving id of hero
macro heroID(h):
    getAllHeroes().index(h)

# Check if player is playing hero
macro isHero(player, hero):
    (player.getCurrentHero() == hero) or (player.getHeroOfDuplication() == hero)

# Macro function for converting decimal to percent
macro percent(p):
    100*(p)

# Macro function for converting percent to decimal 
macro unpercent(p):
    (p)/100

# Macro function for converting decimal to percent
macro roundedPercent(p):
    round(percent(p))

# Macro function for computing a percent of number
macro percentOf(p, n):
    (p)/100*(n)

# Convert angle in degrees to radians
macro toRadians(deg):
    (Math.PI/180)*deg

# Get Facing direction normalized to the XZ plane
macro getForwardDirection(player):
    worldVector(Vector.FORWARD, player, Transform.ROTATION)

# Rotates vector around the y-axis in 3D space
# See https://stackoverflow.com/q/14607640 for formula on rotating vector in 3D space
macro rotateRelativeToYAxis(v, angle_in_degrees):
    vect((v.x*cosDeg(angle_in_degrees) + v.z*sinDeg(angle_in_degrees)), (v.y), (-v.x*sinDeg(angle_in_degrees) + v.z*cosDeg(angle_in_degrees)))

macro cancelMomentum(player):
    player.applyImpulse(player.getVelocity(), -player.getSpeed(), Relativity.TO_WORLD, Impulse.INCORPORATE_CONTRARY_MOTION)

macro centerMass(player):
    (player.getPosition() + player.getEyePosition())/2

macro isCCd(player):
    (player.hasStatusEffect(Status.STUNNED) \
  or isHacked(player) \
  or player.hasStatusEffect(Status.ASLEEP) \
  or player.hasStatusEffect(Status.FROZEN) \
  or player.hasStatusEffect(Status.KNOCKED_DOWN))

# Angle of reflection formula from https://math.stackexchange.com/q/13261
macro reflection(d, n):
    d - 2 * (dotProduct(d, n)) * n

# Start firing primary fire if holding button down.
# def startFiring():
    # @Name "[macro_functions.opy]: startFiring()"
macro startFiring():
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE): 
        eventPlayer.startForcingButton(Button.PRIMARY_FIRE) 
        waitUntil(not eventPlayer.isHoldingButton(Button.PRIMARY_FIRE), Math.INFINITY) 
        eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)

# Stop firing if not.
macro stopFiring():
    if eventPlayer.isHoldingButton(Button.PRIMARY_FIRE): 
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)