{System, ChargedSystem} = require '../BaseSystem'
Cargo = require '../Cargo'

C = require '../Constants'

up_to = ( n ) ->
    Math.floor(Math.random() * n)


class WarpSystem extends ChargedSystem

    @POWER =
        min: 0.01
        max: 1.5
        dyn: 4e5

    @FEDERATION_WARP_SIGNATURE =  [
        0.025477707
        0.2038216561
        0.2547770701
        0.2038216561
        0.127388535
        0.0891719745
        0.050955414
        0.025477707
        0.0127388535
        0.0063694268
    ]

    # If the nacels are completely charged down, it should take a while
    # to recharge them. Charge isn't actively consumed in use, however
    @CHARGE_TIME = 2 * 60 * 1000
    @MAX_WARP = 7


    constructor: ( @name, @deck, @section, @power_thresholds ) ->

        if not @power_thresholds?
            @power_thresholds = WarpSystem.POWER

        super @name, @deck, @section, @power_thresholds

        @_repair_reqs = []
        @_repair_reqs[Cargo.COMPUTER_COMPONENTS] = up_to 20
        @_repair_reqs[Cargo.EPS_CONDUIT] = up_to 20
        @_repair_reqs[Cargo.WARP_PLASMA] = up_to 30
        @_repair_reqs[Cargo.DILITHIUM] = 5
        @_initiate_coil_output()
        @charge_time = WarpSystem.CHARGE_TIME


    _initiate_coil_output: () ->

        # Inherit the base coil balance...
        # +/- 5% on each node
        @coil_balance = []
        for c in WarpSystem.FEDERATION_WARP_SIGNATURE
            @coil_balance.push(
                c * ( 1 + ( 0.05 - Math.random() * 0.1 ))
            )


    warp_field_output: () ->
        if not @online
            return []
        r = ( c * @power * C.WARP_POWER_FIELD_MULTIPLIER for c in @coil_balance )



exports.WarpSystem = WarpSystem