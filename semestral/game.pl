:- ensure_loaded(levels).
:- ensure_loaded(itemsEntities).
:- ensure_loaded(logic).
:- ensure_loaded(stats).
game :-
    currentRoom(Jmeno),
    %Last level
    (Jmeno = "level 8" ->
        writeln("\033[32mYou won the game by nocliping back to reality !\033[0m"),
        newGame()
        ;
        level(Jmeno,_,_,_,_,Popis),
        write('You found yourself in : '),
        write(Jmeno), nl,
        write(Popis),nl,
        waitToRead(),
        wander(10,0),
        sleep(1.5),
        write("You found yourself in a weird hallway. Where does is lead ? "),nl,
        write("You can go in any direction, remember however, that space does not work as you are used to."),
        nl
    ).
    


start:-
    beginDesc(X),
    write(X),
    nl,
    waitToRead(),
    assert(currentRoom("level 0")),
    assert(inventory([])),
    assert(playerHp(100)),
    assert(playerDmg(5)),
    assert(playerSpeed(3)),
    assert(chestsOpened(0)),
    game().
godMode:-
    assert(currentRoom("level 0")),
    beginDesc(X),
    write(X),
    nl,
    assert(inventory([])),
    assert(playerHp(1000000)),
    assert(playerDmg(50000)),
    assert(playerSpeed(30000)),
    assert(chestsOpened(0)),
    game().

newGame:- 
    writeln("New game ? (y/n)"),
    read(C),
    (C = y ->
        purgeDb(), 
        start()
        ;
    C = n ->
        halt
        ;
        write("Wrong input, try again"),
        newGame()).

