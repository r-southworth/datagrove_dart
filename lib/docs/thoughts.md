
# Building code: TDD
A good place to start is is to get the interfaces written as an abstract class.  Commit that. Then you can translate the unit tests (and make your own). Commit that (at this point they will all fail).

Then each time you get a test to work, commit that.

In this case (unreleased code), if you can't figure something out, commit that and then text me. Once the package is released, you shouldn't do this any more since users may be pulling from main (they should be pulling from tags, but...). So after release, you would fork, commit to the fork, and then text me.

# Race Conditions

If you ask a group of people to clean the kitchen and take out the trash its unspecified how much trash on the counter will be at the curb or in your trash can. You might care to specify: first clean the kitchen, then take out the trash. 

In this case both of these approaches is correct, with different tradeoffs. Most of the time race conditions are bugs that will crash your program at the most inopportune time, or worse, provide an access point for an attacker. 

## Dart

```dart
toCleanFast() async {
    Future.wait([
        cleanKitchen(),
        takeOutTrash()
        ])
}


toCleanForWeek() async {
    await cleanKitchen();
    await takeOutTrash();
}

var food;
crashRandomly() async {
    getFood()
    food.eat()
}

```



## Go

```go 
toCleanFast()  {
    // hint: use the pargo package to make this a one liner, 
    var m = sync.WaitGroup
    m.Add(2)
    go func(){
        cleanKitchen()
        m.Done()
    }()
    go func(){
        takeOutTrash()
        m.Done()
    }()
    m.Wait()
}

toCleanForWeek() {
    cleanKitchen()
    takeOutTrash()
}

var food
crashRandomly() {
    go func { food=GetFood()}()
    food.eat()
}
```

---

Consensus


---
Efficiency


---
Work Efficiency
