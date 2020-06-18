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
//:  ## _Observer (Publisher-Subscriber)_
//: ### Наблюдатель — это поведенческий паттерн проектирования, который создаёт механизм подписки, позволяющий одним объектам следить и реагировать на события, происходящие в других объектах.
//:Когда использовать Наблюдатель?
//: * Когда система состоит из множества классов, объекты которых должны находиться в согласованных состояниях
//: * Когда общая схема взаимодействия объектов предполагает две стороны: одна рассылает сообщения и является главным, другая получает сообщения и реагирует на них. Отделение логики обеих сторон позволяет их рассматривать независимо и использовать отдельно друга от друга.
//: * Когда существует один объект, рассылающий сообщения, и множество подписчиков, которые получают сообщения. При этом точное число подписчиков заранее неизвестно и процессе работы программы может изменяться.
//:
//:Участники:
//: * Observable: представляет наблюдаемый объект. Определяет три метода: AddObserver() (для добавления наблюдателя), RemoveObserver() (удаление набюдателя) и NotifyObservers() (уведомление наблюдателей)
//: * ConcreteObservable: конкретная реализация интерфейса Observable. Определяет коллекцию объектов наблюдателей.
//: * Observer: представляет наблюдателя, который подписывается на все уведомления наблюдаемого объекта. Определяет метод Update(), который вызывается наблюдаемым объектом для уведомления наблюдателя.
//: * ConcreteObserver: конкретная реализация интерфейса IObserver.
//:
//: [Более подробно](https://refactoring.guru/ru/design-patterns/observer) и [тут](https://metanit.com/sharp/patterns/3.2.php)
///Observer
protocol Subscriber{
    func Update(stockInfo: StockInfo)
    func isEqualTo(_ other: Subscriber) -> Bool
}

extension Subscriber where Self : Equatable{
    func isEqualTo(_ other: Subscriber) -> Bool {
        guard let otherSubscriber = other as? Self else { return false }
        return self == otherSubscriber
    }
}
///Observable
protocol Publisher{
    var subscribers: [Subscriber] { get set }
     
    func RegisterObserver(subscriber: Subscriber)
    func RemoveObserver(subscriber: Subscriber)
    func NotifyObservers()
}
 
// информация о торгах
class StockInfo{
    var USD: Double = 0
    var Euro: Double = 0
}

class Broker : Subscriber, Equatable{
    
    func Update(stockInfo: StockInfo) {
        if(stockInfo.USD > 61){
            print("Брокер \(self.name) продает доллары;  Курс доллара: \(stockInfo.USD)")
        }
        else{
            print("Брокер \(self.name)  покупает доллары;  Курс доллара: \(stockInfo.USD)")
        }
    }
    
    static func == (lhs: Broker, rhs: Broker) -> Bool {
        return lhs.id == rhs.id
    }

    let name: String
    let id = UUID()
    var stock: Stock
    
    init(name: String, stock: Stock)
    {
        self.name = name
        self.stock = stock
        stock.RegisterObserver(subscriber: self)
    }
    
    func StopTrade(){
        self.stock.RemoveObserver(subscriber: self)
    }
}

class Bank : Subscriber, Equatable{
    
    static func == (lhs: Bank, rhs: Bank) -> Bool {
        return lhs.id == rhs.id
    }
    
    let name: String
    let id = UUID()
    var stock: Stock
    
    init(name: String, stock: Stock){
        self.name = name
        self.stock = stock
        stock.RegisterObserver(subscriber: self)
    }
    
    func Update(stockInfo: StockInfo) {
        if (stockInfo.Euro > 76){
            print("Банк \(self.name) продает евро;  Курс евро: \(stockInfo.Euro)")
        }
        else{
            print("Банк \(self.name) покупает евро;  Курс евро: \(stockInfo.Euro)")
        }
    }
}

//биржа
final class Stock: Publisher{
    var subscribers: [Subscriber]
    
    //акции
    var sInfo: StockInfo
    
    func RegisterObserver(subscriber: Subscriber) {
        self.subscribers.append(subscriber)
    }

    func RemoveObserver(subscriber: Subscriber){
        if let index = self.subscribers.firstIndex(where: {$0.isEqualTo(subscriber) }){
            self.subscribers.remove(at: index)
        }
    }

    func NotifyObservers() {
        for subscriber in self.subscribers{
            subscriber.Update(stockInfo: sInfo)
        }
    }
 
    func Trade(){
        sInfo.USD = Double.random(in: 60.0 ..< 70.0)
        sInfo.Euro = Double.random(in: 70.0 ..< 80.0)
        self.NotifyObservers()
    }
    
    init(){
        self.subscribers = [Subscriber]()
        self.sInfo = StockInfo()
    }
}

var stock = Stock()
var bank = Bank(name: "ЮнитБанк", stock: stock)
var broker = Broker(name: "Иван Иваныч", stock: stock)
// имитация торгов
stock.Trade()
// брокер прекращает наблюдать за торгами
broker.StopTrade()
// имитация торгов
stock.Trade()
stock.Trade()
//:  ## _Iterator_
//: ### Итератор — это поведенческий паттерн проектирования, который даёт возможность последовательно обходить элементы составных объектов, не раскрывая их внутреннего представления.
//:Когда использовать итератор?
//: * Когда необходимо осуществить обход объекта без раскрытия его внутренней структуры
//: * Когда имеется набор составных объектов, и надо обеспечить единый интерфейс для их перебора
//: * Когда необходимо предоставить несколько альтернативных вариантов перебора одного и того же объекта
//:
//:Участники:
//: * Iterator: определяет интерфейс для обхода составных объектов
//: * Aggregate: определяет интерфейс для создания объекта-итератора
//: * ConcreteIterator: конкретная реализация итератора для обхода объекта Aggregate. Для фиксации индекса текущего перебираемого элемента использует целочисленную переменную _current
//: * ConcreteAggregate: конкретная реализация Aggregate. Хранит элементы, которые надо будет перебирать
//: * Client: использует объект Aggregate и итератор для его обхода
//:
//: [Более подробно](https://refactoring.guru/ru/design-patterns/iterator) и [тут](https://metanit.com/sharp/patterns/3.5.php)
struct SuffixIterator : IteratorProtocol{
    
    //state:
    let string: String
    var last : String.Index
    var offset: String.Index
    
    init(string: String) {
        self.string = string
        self.last = string.endIndex
        self.offset = string.startIndex
    }
    
    mutating func next() -> Substring?{
        guard offset < last else { return nil }
        let sub: Substring = string[offset..<last]
        string.formIndex(after: &offset)
        return sub
    }
}

struct SuffixSequence: Sequence {
    
    let string: String
    
    func makeIterator() -> SuffixIterator{
        return SuffixIterator(string: string)
    }
}

for suffix in SuffixSequence(string: "Pattern Iterator"){
    print(suffix)
}
//:  ## _State_
//: ### Состояние — это поведенческий паттерн проектирования, который позволяет объектам менять поведение в зависимости от своего состояния. Извне создаётся впечатление, что изменился класс объекта.
//:Когда использовать паттерн?
//: * Когда поведение объекта должно зависеть от его состояния и может изменяться динамически во время выполнения
//: * Когда в коде методов объекта используются многочисленные условные конструкции, выбор которых зависит от текущего состояния объекта
//:
//:Участники:
//: * State: определяет интерфейс состояния
//: * Классы StateA и StateB - конкретные реализации состояний
//: * Context: представляет объект, поведение которого должно динамически изменяться в соответствии с состоянием. Выполнение же конкретных действий делегируется объекту состояния
//:
//: [Более подробно](https://refactoring.guru/ru/design-patterns/state) и [тут](https://metanit.com/sharp/patterns/3.6.php)
///State:
protocol WaterState{
    func Heat()-> WaterState
    func Frost()-> WaterState
}
///Context:
class  Water{
    var state: WaterState
    
    init (state: WaterState){
        self.state = state
    }
    func Heat() {
        self.state = state.Heat()
    }
    
    func Frost() {
        self.state = state.Frost()
    }
}
///StateA:
class SolidWaterState : WaterState{
    var water: Water?
    
    func Heat() -> WaterState{
        print("Превращаем лед в жидкость")
        
        return LiquidWaterState()
    }
    
    func Frost() -> WaterState{
        print("Продолжаем заморозку льда")
        return SolidWaterState()
    }
}
///StateB:
class LiquidWaterState : WaterState{
    func Heat() -> WaterState{
        print("Превращаем жидкость в пар")
        return GasWaterState()
    }
    
    func Frost() -> WaterState{
        print("Превращаем жидкость в лед")
        return SolidWaterState()
    }
}
///StateC:
class GasWaterState : WaterState{
    func Heat() -> WaterState{
        print("Повышаем температуру водяного пара")
        return GasWaterState()
    }
    
    func Frost() -> WaterState {
        print("Превращаем водяной пар в жидкость")
        return LiquidWaterState()
    }
}

var water = Water(state: LiquidWaterState())
water.Heat()
water.Heat()
water.Frost()
water.Frost()
water.Heat()
//:  ## _Chain of responsibility_
//: ### Цепочка обязанностей — это поведенческий паттерн проектирования, который позволяет передавать запросы последовательно по цепочке обработчиков. Каждый последующий обработчик решает, может ли он обработать запрос сам и стоит ли передавать запрос дальше по цепи.
//:Когда использовать паттерн?
//: * Когда имеется более одного объекта, который может обработать определенный запрос
//: * Когда надо передать запрос на выполнение одному из нескольких объект, точно не определяя, какому именно объекту
//: * Когда набор объектов задается динамически
//:
//:Участники:
//: * Handler: определяет интерфейс для обработки запроса. Также может определять ссылку на следующий обработчик запроса
//: * ConcreteHandler1 и ConcreteHandler2: конкретные обработчики, которые реализуют функционал для обработки запроса. При невозможности обработки и наличия ссылки на следующий обработчик, передают запрос этому обработчику
//: * Client: отправляет запрос объекту Handler
//:
//: [Более подробно](https://refactoring.guru/ru/design-patterns/chain-of-responsibility) и [тут](https://metanit.com/sharp/patterns/3.7.php)
class Receiver{
    // банковские переводы
    let BankTransfer: Bool?
    // денежные переводы - WesternUnion, Unistream
    let MoneyTransfer: Bool?
    // перевод через PayPal
    let PayPalTransfer: Bool?
    
    init(bt : Bool, mt: Bool, ppt: Bool)
    {
        BankTransfer = bt
        MoneyTransfer = mt
        PayPalTransfer = ppt
    }
}

protocol PaymentHandler{
    var successor: PaymentHandler? { get }
    func Handle(receiver: Receiver)
}
 
final class BankPaymentHandler : PaymentHandler
{
    var successor: PaymentHandler?
    
    func Handle(receiver: Receiver){
        if (receiver.BankTransfer == true){
            print("Выполняем банковский перевод")
        } else {self.successor?.Handle(receiver: receiver)}
    }
}
 
final class PayPalPaymentHandler : PaymentHandler{
    var successor: PaymentHandler?
    
    func Handle(receiver: Receiver){
        if (receiver.PayPalTransfer == true){
            print("Выполняем перевод через PayPal")
        } else {self.successor?.Handle(receiver: receiver)}
    }
}
// переводы с помощью системы денежных переводов
final class MoneyPaymentHandler : PaymentHandler
{
    var successor: PaymentHandler?
    
    func Handle(receiver: Receiver){
        if (receiver.MoneyTransfer == true){
            print("Выполняем перевод через системы денежных переводов")
        }
        else {self.successor?.Handle(receiver: receiver)}
    }
}

var bankPaymentHandler = BankPaymentHandler()
var moneyPaymentHadler =  MoneyPaymentHandler()
var paypalPaymentHandler =  PayPalPaymentHandler()
bankPaymentHandler.successor = paypalPaymentHandler
paypalPaymentHandler.successor = moneyPaymentHadler
let receiver = Receiver(bt: false, mt: true, ppt: true)
bankPaymentHandler.Handle(receiver: receiver)
//:  ## _Visitor_
//: ### Посетитель — это поведенческий паттерн проектирования, который позволяет добавлять в программу новые операции, не изменяя классы объектов, над которыми эти операции могут выполняться.
//:Когда использовать паттерн?
//: * Когда имеется много объектов разнородных классов с разными интерфейсами, и требуется выполнить ряд операций над каждым из этих объектов
//: * Когда классам необходимо добавить одинаковый набор операций без изменения этих классов
//: * Когда часто добавляются новые операции к классам, при этом общая структура классов стабильна и практически не изменяется
//:
//:Участники:
//: * Visitor: интерфейс посетителя, который определяет метод Visit() для каждого объекта Element
//: * ConcreteVisitor1 / ConcreteVisitor2: конкретные классы посетителей, реализуют интерфейс, определенный в Visitor.
//: * Element: определяет метод Accept(), в котором в качестве параметра принимается объект Visitor
//: * ElementA / ElementB: конкретные элементы, которые реализуют метод Accept()
//: *ObjectStructure: некоторая структура, которая хранит объекты Element и предоставляет к ним доступ. Это могут быть и простые списки, и сложные составные структуры в виде деревьев
//:
//: [Более подробно](https://refactoring.guru/ru/design-patterns/visitor) и [тут](https://metanit.com/sharp/patterns/3.11.php)
///Visitor
protocol Visitor{
    func VisitPersonAcc(person: Person)
    func VisitCompanyAc(company: Company)
}
 
///ConcreteVisitor1
// сериализатор в HTML
class HtmlVisitor : Visitor
{
    func VisitPersonAcc(person: Person) {
        var result = "<table><tr><td>Свойство<td><td>Значение</td></tr>"
        result += "<tr><td>Name<td><td>\(String(describing: person.name))</td></tr>"
        result += "<tr><td>Number<td><td>\(String(describing: person.number))</td></tr></table>"
        print(result)
    }
    
    func VisitCompanyAc(company: Company) {
        var result = "<table><tr><td>Свойство<td><td>Значение</td></tr>"
        result += "<tr><td>Name<td><td>\(String(describing: company.name))</td></tr>"
        result += "<tr><td>RegNumber<td><td>\(String(describing: company.regNumber))</td></tr>"
        result += "<tr><td>Number<td><td>\(String(describing: company.number))</td></tr></table>"
        print(result)
    }
}
 
///ConcreteVisitor2
// сериализатор в XML
class XmlVisitor : Visitor
{
    func VisitPersonAcc(person: Person) {
        let result = "<Person><Name>\(String(describing: person.name))</Name><Number>\(String(describing: person.number))</Number><Person>"
        print(result)
    }
    
    func VisitCompanyAc(company: Company) {
        let result = "<Company><Name>\(String(describing: company.name))</Name><RegNumber>\(String(describing: company.regNumber))</RegNumber><Number>\(String(describing: company.number))</Number><Company>"
        print(result)
    }
}
 
class BankTrust{
    var accounts = [Account]()
    
    func Add(acc: Account){
        accounts.append(acc)
    }

    func Accept(visitor: Visitor){
        for acc in self.accounts {
            acc.Accept(visitor: visitor)
        }
    }
}
 
protocol Account{
    func Accept(visitor: Visitor)
}
 
class Person : Account
{
    var name: String
    var number: String
 
    func Accept(visitor: Visitor){
        visitor.VisitPersonAcc(person: self)
    }
    init(_ name: String, _ number: String){
        self.name = name
        self.number = number
    }
}
 
class Company : Account
{
    var name: String
    var regNumber: String
    var number: String
 
    func Accept(visitor: Visitor){
        visitor.VisitCompanyAc(company: self)
    }
    init(_ name: String,_ regNumber: String, _ number: String){
        self.name = name
        self.regNumber = regNumber
        self.number = number
    }
}

var structure = BankTrust()
structure.Add(acc: Person("Иван Алексеев", "82184931"))
structure.Add(acc: Company("Apple","ewuir32141324","3424131445"))
structure.Accept(visitor: HtmlVisitor())
structure.Accept(visitor: XmlVisitor())
//: [к содержанию](Intro)
//:
//: [к порождающим паттернам](CreationalPatterns)
//:
//: [к структурным паттернам](StructuralPatterns)
