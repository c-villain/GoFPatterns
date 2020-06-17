//: [к содержанию](Intro)
//:
//: [к порождающим паттернам](CreationalPatterns)
//:
//: [к структурным паттернам](StructuralPatterns)
import Foundation
//: # _Поведенческие паттерны_
//:
//:  ## _Command_
//: ### Команда — это поведенческий паттерн проектирования, который превращает запросы в объекты, позволяя передавать их как аргументы при вызове методов, ставить запросы в очередь, логировать их, а также поддерживать отмену операций.
//:Участники:
//: * Command: интерфейс, представляющий команду. Обычно определяет метод Execute() для выполнения действия, а также нередко включает метод Undo(), реализация которого должна заключаться в отмене действия команды
//: * ConcreteCommand: конкретная реализация команды, реализует метод Execute(), в котором вызывается определенный метод, определенный в классе Receiver
//: * Receiver: получатель команды. Определяет действия, которые должны выполняться в результате запроса.
//: * Invoker: инициатор команды - вызывает команду для выполнения определенного запроса
//: * Client: клиент - создает команду и устанавливает ее получателя с помощью метода SetCommand()
//:
//: [Более подробно](https://refactoring.guru/ru/design-patterns/command) и [тут](https://metanit.com/sharp/patterns/3.3.php)

///Command
protocol Command{
    func Execute()
    func Undo()
}

///Receiver
struct Microwave{
    func startCooking(){
        print("Подогреваем еду")
    }
 
    func stopCooking(){
        print("Еда подогрета!")
    }
    
    func cancelCooking(){
        print("Отменить подогрев!")
    }
}

///ConcreteCommand
struct MicrowaveCommand : Command{
    let microwave: Microwave

    func Execute() {
        microwave.startCooking()
        microwave.stopCooking()
    }
    
    func Undo() {
        microwave.cancelCooking()
    }
    
    init(microwave: Microwave){
        self.microwave = microwave
    }
}

let microwave = Microwave()
let command = MicrowaveCommand(microwave: microwave)
command.Execute()
command.Undo()

//:  ## _Strategy_
//: ### Стратегия — это поведенческий паттерн проектирования, который определяет семейство схожих алгоритмов и помещает каждый из них в собственный класс, после чего алгоритмы можно взаимозаменять прямо во время исполнения программы.
//:Участники:
//: * Интерфейс Strategy: бщий интерфейс для всех реализующих его алгоритмов.
//: * Классы ConcreteStrategy1 и ConcreteStrategy, которые реализуют интерфейс Strategy, предоставляя свою версию метода Algorithm(). Подобных классов-реализаций может быть множество.
//: * Класс Context хранит ссылку на объект Strategy и связан с интерфейсом Strategy отношением агрегации.
//:
//: [Более подробно](https://refactoring.guru/ru/design-patterns/strategy) и [тут](https://metanit.com/sharp/patterns/3.1.php)

///Strategy
protocol Movable
{
    func move()
}

///ConcreteStrategy1
struct PetrolMove : Movable{
    func move(){
        print("Перемещение на бензине")
    }
}

///ConcreteStrategy2
struct ElectricMove : Movable{
    func move(){
        print("Перемещение на электричестве")
    }
}

///Context
struct Car{
    let passengers: Int // кол-во пассажиров
    let model: String // модель автомобиля
    var strategy: Movable
    
    init(passengers: Int, model: String , strategy: Movable ){
        self.passengers = passengers
        self.model = model
        self.strategy = strategy
    }
    
    func move(){
        strategy.move()
    }
}

var auto = Car(passengers: 4, model: "Volvo", strategy: PetrolMove())
auto.move()
auto.strategy = ElectricMove()
auto.move();

//:  ## _Mediator_
//: ### Медиатор — это поведенческий паттерн проектирования, который позволяет уменьшить связанность (reduce coupling) множества классов между собой, благодаря перемещению этих связей в один класс-посредник.
//:Когда используется паттерн Посредник?
//: * Когда имеется множество взаимосвязаных объектов, связи между которыми сложны и запутаны.
//: * Когда необходимо повторно использовать объект, однако повторное использование затруднено в силу сильных связей с другими объектами.
//:
//:Участники:
//: * Mediator: представляет интерфейс для взаимодействия с объектами Colleague
//: * Colleague: представляет интерфейс для взаимодействия с объектом Mediator
//: * ConcreteColleague1 и ConcreteColleague2: конкретные классы коллег, которые обмениваются друг с другом через объект Mediator
//: * ConcreteMediator: конкретный посредник, реализующий интерфейс типа Mediator
//:
//: [Более подробно](https://refactoring.guru/ru/design-patterns/mediator) и [тут](https://metanit.com/sharp/patterns/3.9.php)

///Mediator
protocol Mediator{
    func send(message: String, from colleague: Colleague)
}

protocol Colleague{
    var mediator: Mediator { get set }
    
    func send(message: String)

    func notify(message: String);
}

extension Colleague{
    func send(message: String){
        mediator.send(message: message, from: self)
    }
}

// класс заказчика
struct CustomerColleague : Colleague{
    var mediator: Mediator
    
    func notify(message: String){
        print("Сообщение заказчику: \(message)")
    }
}

// класс программиста
struct ProgrammerColleague : Colleague{
    var mediator: Mediator
    
    func notify(message: String){
        print("Сообщение программисту: \(message)")
    }
}

// класс тестера
struct TesterColleague : Colleague{
    var mediator: Mediator
    
    func notify(message: String){
        print("Сообщение тестировщику: \(message)")
    }
}
 
class ManagerMediator : Mediator{

    var customer: Colleague?
    var programmer: Colleague?
    var tester: Colleague?

    func send(message: String, from colleague: Colleague) {
        // если отправитель - заказчик, значит есть новый заказ
        // отправляем сообщение программисту - выполнить заказ
        if (colleague is CustomerColleague){
            programmer?.notify(message: message)
        }
        // если отправитель - программист, то можно приступать к тестированию
        // отправляем сообщение тестеру
        else if (colleague is ProgrammerColleague){
            tester?.notify(message: message)
        }
        // если отправитель - тест, значит продукт готов
        // отправляем сообщение заказчику
        else if (colleague is TesterColleague){
            customer?.notify(message: message)
        }
    }
}

var mediator = ManagerMediator()
var customer = CustomerColleague(mediator: mediator)
var programmer =  ProgrammerColleague(mediator: mediator)
var tester =  TesterColleague(mediator: mediator)

mediator.customer = customer
mediator.programmer = programmer
mediator.tester = tester

customer.send(message: "Есть заказ, надо сделать программу")
programmer.send(message: "Программа готова, надо протестировать")
tester.send(message: "Программа протестирована и готова к продаже")

//:  ## _Template_
//: ### Шаблонный метод — это поведенческий паттерн проектирования, который определяет скелет алгоритма, перекладывая ответственность за некоторые его шаги на подклассы. Паттерн позволяет подклассам переопределять шаги алгоритма, не меняя его общей структуры.
//:Когда использовать шаблонный метод?
//: * Когда планируется, что в будущем подклассы должны будут переопределять различные этапы алгоритма без изменения его структуры
//: * Когда в классах, реализующим схожий алгоритм, происходит дублирование кода. Вынесение общего кода в шаблонный метод уменьшит его дублирование в подклассах.
//:
//:Участники:
//: * AbstractClass: определяет шаблонный метод TemplateMethod(), который реализует алгоритм. Алгоритм может состоять из последовательности вызовов других методов, часть из которых может быть абстрактными и должны быть переопределены в классах-наследниках. При этом сам метод TemplateMethod(), представляющий структуру алгоритма, переопределяться не должен.
//: * ConcreteClass: подкласс, который может переопределять различные методы родительского класса.
//:
//: [Более подробно](https://refactoring.guru/ru/design-patterns/template-method) и [тут](https://metanit.com/sharp/patterns/3.4.php)

///AbstractClass
protocol Education{
    func Learn()
    func Enter();
    func Study();
    func PassExams()
    func GetDocument();
}

///ConcreteClass
extension Education{
    
    func PassExams(){
        print("Сдаем выпуксные экзамены!")
    }
    
    func Learn(){
        Enter();
        Study();
        PassExams();
        GetDocument();
    }
}

class School : Education
{
    func Enter(){
        print("Идем в первый класс")
    }
 
    func Study(){
        print("Посещаем уроки, делаем домашние задания")
    }
 
    func GetDocument(){
        print("Получаем аттестат о среднем образовании")
    }

}
let school = School()
school.Learn()

//:  ## _Memento_
//: ### Снимок — это поведенческий паттерн проектирования, который позволяет сохранять и восстанавливать прошлые состояния объектов, не раскрывая подробностей их реализации.
//:Когда использовать Memento?
//: * Когда нужно сохранить состояние объекта для возможного последующего восстановления.
//: * Когда сохранение состояния должно проходить без нарушения принципа инкапсуляции.
//:
//:Участники:
//: * Memento: хранитель, который сохраняет состояние объекта Originator и предоставляет полный доступ только этому объекту Originator
//: * Originator: создает объект хранителя для сохранения своего состояния
//: * Caretaker: выполняет только функцию хранения объекта Memento, в то же время у него нет полного доступа к хранителю и никаких других операций над хранителем, кроме собственно сохранения, он не производит
//:
//: [Более подробно](https://refactoring.guru/ru/design-patterns/memento) и [тут](https://metanit.com/sharp/patterns/3.10.php)
 
// Memento
class HeroMemento{
    var patrons: Int
    var lives: Int
 
    init (_ patrons: Int, _ lives: Int)
    {
        self.patrons = patrons
        self.lives = lives
    }
}

// Originator
class Hero{
    var patrons = 10 // кол-во патронов
    var lives = 5 // кол-во жизней
 
    func Shoot(){
        if (patrons > 0)
        {
            patrons -= 1;
            print("Производим выстрел. Осталось \(patrons) патронов")
        }
        else { print("Патронов больше нет") }
    }
    // сохранение состояния
    func SaveState()-> HeroMemento{
        print("Сохранение игры. Параметры: \(patrons) патронов, \(lives) жизней")
        return HeroMemento(patrons, lives)
    }
 
    // восстановление состояния
    func RestoreState(memento: HeroMemento){
        self.patrons = memento.patrons;
        self.lives = memento.lives;
        print("Восстановление игры. Параметры: \(patrons) патронов, \(lives) жизней")
    }
}
   
// Caretaker
class GameHistory{
    var History = [HeroMemento]()
}

var hero = Hero()
hero.Shoot() // делаем выстрел, осталось 9 патронов
var game = GameHistory()

game.History.append(hero.SaveState()) // сохраняем игру

hero.Shoot() //делаем выстрел, осталось 8 патронов

hero.RestoreState(memento: game.History.last!)

hero.Shoot(); //делаем выстрел, осталось 8 патронов


//: [к содержанию](Intro)
//:
//: [к порождающим паттернам](CreationalPatterns)
//:
//: [к структурным паттернам](StructuralPatterns)
