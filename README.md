# number_trivia

#### *project structure*
> here's general picture of clean flutter architecture

![](./pics/general_cleran_flutter_architecture.webp)

```
persentation is comprised of widgets in this case
like number trivia page and logic holders some state
managment in this case i intend to use bloc
```

```
this layer should be indpendent on any othe layer
it will contain the core buisness logic which will
be excuted inside usecases and also buisness objects
aka entity
```

### Implementation

> first as suggested by uncle bob we should start in the entity
so i will make numberTrivia entity that should be able to hold
text and number

> usecase will use repository and get number trivia but repository
can not just return numberTrivia it will return Future < NumberTriva >
but what about errors is it good to allow exception to go above layer
for me it's not so we will return either Failure object or NumberTrivia
entity in repository but how can one function return different stuff
that's will solved using dartz package

<h4 style="color:blue"> Domain layer </h4>

**Entity**

```
we need to ask what kind of data that our app will utilize
well numberTrivia entities of course that have text and number
```

**Use Cases**

```
our app will need get concrete number trivia
and get random number trivia and each use case will
use repository to get/execute this buisness logic
```

**Repository**

```
we will define how the respitory should look like it should have
two methods one for getConcreteNumberTrivia and one for
getRandomNumberTrivia
```