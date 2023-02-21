%updates stats based on scaling ratio - HP and speed stack, damage does not so the best is chosen.
updateStats(Item):-
    itemScalingRatio(ItemScalingRatio),
    chestsOpened(ChestsOpened),
    Item = item(_,[_HP=HPValue,_DMG=DMGValue,_SPEED=SPEEDValue]),
    playerHp(CurrHp),
    playerSpeed(CurrSpeed),
    playerDmg(CurrDmg),
    NSpeed is CurrSpeed + (SPEEDValue *  ItemScalingRatio * ChestsOpened),
    NHp is (CurrHp + (HPValue * ItemScalingRatio  * ChestsOpened)),
    retract(playerHp(CurrHp)),
    assert(playerHp(NHp)),
    retract(playerSpeed(CurrSpeed)),
    assert(playerSpeed(NSpeed)),
    NDmg is (DMGValue * (1 + (ItemScalingRatio  * ChestsOpened))),  
    (NDmg > CurrDmg ->
        retract(playerDmg(CurrDmg)),
        assert(playerDmg(NDmg)),
        writeStats()
        ;
        writeStats()
    ).
    


writeStats():-
    write("U have the following stats: "),
    playerDmg(Dmg),
    playerHp(Hp),
    playerSpeed(Speed),
    format('~1f', Dmg),
    write(" dmg, "),
    format('~1f', Hp),
    write(" hp and "),
    format('~1f', Speed),
    write(" speed."),
    nl.

writeFightStats(EntityHp,EntityDmg):-
    playerDmg(Dmg),
    playerHp(Hp),
    write("U had: "),
    format('~1f', Hp),
    write(" hp and: "),
    format('~1f', Dmg),
    write(" dmg, The entity had: "),
    format('~1f' , EntityHp),
    write(" hp and: "),
    format('~1f', EntityDmg),
    write(" dmg"),
    nl.