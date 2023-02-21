
:- dynamic currentRoom/1.
:- dynamic inventory/1.
:- dynamic playerHp/1.
:- dynamic playerSpeed/1.
:- dynamic playerDmg/1.
:- dynamic chestsOpened/1.
:- dynamic entityScalingRatio/1.
:- dynamic itemScalingRatio/1.

entityScalingRatio(0.4). % <- set as u wish, the bigger the number, the fast will the entites stats increase. default: 0.4
itemScalingRatio(0.2). % <- set as u wish, the bigger the number, the fast will the items stats increase. default: 0.2

randomEntity():-
    findall(entity(Name, Attribs), entity(Name, Attribs), Lst),
    random_member(Ent,Lst),
    Ent = entity(Name, [_Hp=_HPValue,_Dmg=_DMGValue,_Speed=_SPEEDValue]),
    writeln(Name),
    encounter(Ent).

encounter(Ent):-
    write("\033[32mDo you wanna fight or try to flee ?\033[0m"),nl,
    write("y/n"),nl,
    read(C),
    (C = y -> 
        fight(Ent)
        ;
    C = n ->
        chase(Ent)
        ;
        write("Wrong input, try again"),
        encounter(Ent)
        ).
%No random chance involved, pure stat battle
fight(Entity) :-
    entityScalingRatio(EntityScalingRatio),
    chestsOpened(ChestsOpened),
    playerHp(PlayerHp),
    playerDmg(PlayerDmg),
    Entity = entity(_Name, [health=OldEntityHp, damage=OldEntityDmg, _Speed=_OldEntitySpeed]),
    EntityDmg is ((1 + (EntityScalingRatio * ChestsOpened)) * OldEntityDmg),
   
    EntityHp is ((1 + (EntityScalingRatio * ChestsOpened)) * OldEntityHp),
    
    writeFightStats(EntityHp,EntityDmg),
    wait(5),
    (EntityHp / PlayerDmg > PlayerHp / EntityDmg -> 
    writeln("U lost "),
    writeln("\033[31mYou are Dead\033[0m"),
    newGame()
    ;
    writeln("\033[32mYou win!\033[0m"),
    openChest()
    ).
%added for extra tension
wait(Seconds) :-
    (Seconds > 0 ->
        write("."),
        flush_output,
        sleep(1),
        wait(Seconds - 1);
        nl,
        true).
% 60% speed 40% random chance to win 
chase(Entity):-
    entityScalingRatio(EntityScalingRatio),
    chestsOpened(ChestsOpened),
    Entity = entity(_Name, [_, _, _Speed=OldEntitySpeed]),
    random(1,40,Val),
    random(1,40,Val2),
    EntitySpeed is ((1 + (EntityScalingRatio * ChestsOpened)) * OldEntitySpeed),
    playerSpeed(PlayerSpeed),
    write("Your speed stat was : "),
    write(PlayerSpeed),
    write(", the entities was : "),
    write(EntitySpeed),
    write("."),
    nl,
    wait(5),
   
    ((PlayerSpeed * 6) + Val >  (EntitySpeed * 6) + Val2 ->
        writeln("\033[32mYou managed to escape!\033[0m")
        ;
        writeln("U have been chased down"),
        writeln("\033[31mYou are Dead\033[0m"),
        newGame()).
   
%Handles duplicates by saving quantity
addItem(Item) :-
    inventory(Inventory),
    (member([Item,Q],Inventory)
    ->
        delete(Inventory,[Item,Q],Res1),
        succ(Q,Q1),
        append(Res1,[[Item,Q1]],Res)
    ;
        append(Inventory,[[Item,1]],Res)
    ),
    retract(inventory(Inventory)),
    assert(inventory(Res)).

%Decreases items quantity, it not being used
useItem(Item) :-
    inventory(Inventory),
    (member([Item,Q],Inventory) ->
        delete(Inventory,[Item,Q],Res1),
        succ(Q1,Q),
        (Q1 > 0 ->
            append(Res1,[[Item,Q1]],Res)
            ;
                true)
    ;
    write("Item not in inventory"), nl
    ),
    retract(inventory(Inventory)),
    assert(inventory(Res)).

waitToRead():-
    writeln("\033[32mType anything to continue\033[0m"),
    read(_).

openChest():-
    chestsOpened(C),
    retract(chestsOpened(C)),
    assert(chestsOpened(C+1)),
    findall(item(Name, Attribs), item(Name, Attribs), List),
    random_member(Item,List),
    Item = item(ChosenName,_),
    addItem(Item),
    write(ChosenName),
    writeln(" has been to your inventory"),
    updateStats(Item),
    nl.

    

    
north :-
    currentRoom(X),
    level(X, Y, _, _, _, _),
    retract(currentRoom(X)),
    assert(currentRoom(Y)),
    game().

south :-
    currentRoom(X),
    level(X, _, Y, _, _, _),
    retract(currentRoom(X)),
    assert(currentRoom(Y)),
    game().
west :-
    currentRoom(X),
    level(X, _, _, Y, _, _),
    retract(currentRoom(X)),
    assert(currentRoom(Y)),
    game().
east :-
    currentRoom(X),
    level(X, _, _, _, Y, _),
    retract(currentRoom(X)),
    assert(currentRoom(Y)),
    game().
 

wander(Time, NumIterations) :-
    (NumIterations < Time ->
    write("Wandering..."), nl,
    random(1, 100, DiceRoll),
    (DiceRoll < 20 -> 
        write("You have stumbled upon a chest!"), 
        nl,
        !,
        openChest()
    ;
    DiceRoll > 95 ->
        write("U have encountered an entity."), nl, !, randomEntity()
    ; 
    true),
    sleep(0.5),
    wander(Time, NumIterations + 1);
    true
    ).



purgeDb():-
    currentRoom(CurrRoom),
    inventory(Inv),
    playerHp(Hp),
    playerSpeed(Sp),
    playerDmg(Dmg),
    chestsOpened(CHo),
    retract(currentRoom(CurrRoom)),
    retract(playerHp(Hp)),
    retract(inventory(Inv)),
    retract(playerSpeed(Sp)),
    retract(playerDmg(Dmg)),
    retract(chestsOpened(CHo)).



