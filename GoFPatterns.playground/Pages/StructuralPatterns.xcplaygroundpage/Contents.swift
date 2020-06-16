//: [к содержанию](Intro)
//:
//: [к порождающим паттернам](CreationalPatterns)
//:
//: [к поведенеческим паттернам](BehavioralPatterns)
import Foundation
//: # _Структурные паттерны_
//:
//:  ## _Adapter (wrapper)_
//: ### Адаптер — это структурный паттерн проектирования, который позволяет объектам с несовместимыми интерфейсами работать вместе.
//:Участники:
//: * Target: представляет объекты, которые используются клиентом (класс, к которому надо адаптировать другой класс  )
//: * Client: использует объекты Target для реализации своих задач
//: * Adaptee: представляет адаптируемый класс, который мы хотели бы использовать у клиента вместо объектов Target
//: * Adapter: собственно адаптер, который позволяет работать с объектами Adaptee как с объектами Target.
//:
//: [Более подробно](https://refactoring.guru/ru/design-patterns/adapter) и [тут](https://metanit.com/sharp/patterns/4.2.php)

///Target
protocol Driveable{
    func drive()
}

protocol Traveller{
    func travel(transport: Driveable)
}

///Client
struct Man: Traveller
{
    func travel(transport: Driveable)
    {
        transport.drive();
    }
}

struct Auto: Driveable {
    func drive()
    {
        print("Car is driving on road");
    }
}

protocol Moveable{
    func move()
}


///Adaptee
struct Camel: Moveable {
    func move()
    {
        print("Camel is moving on sand");
    }
}

///Adapter
class CamelToTransportAdapter : Driveable
{
    var camel: Camel
    
    init(camel: Camel){
        self.camel = camel
    }
 
    func drive(){
        self.camel.move()
    }
}

let man = Man()

let auto = Auto()

man.travel(transport: auto)

let camel = Camel()

let camelAdapter = CamelToTransportAdapter(camel: camel)

man.travel(transport: camelAdapter)

//:  ## _Bridge_
//: ### Мост — это структурный паттерн проектирования, который разделяет один или несколько классов на две отдельные иерархии — абстракцию и реализацию, позволяя изменять их независимо друг от друга.
//: ### Когда использовать данный паттерн?
//: * Когда надо избежать постоянной привязки абстракции к реализации
//: * Когда наряду с реализацией надо изменять и абстракцию независимо друг от друга. То есть изменения в абстракции не должно привести к изменениям в реализации
//: ### Участники
//: * Abstraction: определяет базовый интерфейс и хранит ссылку на объект Implementor. Выполнение операций в Abstraction делегируется методам объекта Implementor
//: * RefinedAbstraction: уточненная абстракция, наследуется от Abstraction и расширяет унаследованный интерфейс
//: * Implementor: определяет базовый интерфейс для конкретных реализаций. Как правило, Implementor определяет только примитивные операции. Более сложные операции, которые базируются на примитивных, определяются в Abstraction
//: * ConcreteImplementorA и ConcreteImplementorB: конкретные реализации, которые унаследованы от Implementor
//: * Client: использует объекты Abstraction
//:
//: [Более подробно](https://refactoring.guru/ru/design-patterns/bridge) и [тут](https://metanit.com/sharp/patterns/4.6.php)


///Implementor
protocol Language{
    func Build()
    func Execute()
}
 
///ConcreteImplementorA
struct CPPLanguage : Language{
    func Build(){
        print("С помощью компилятора C++ компилируем программу в бинарный код");
    }
 
    func Execute(){
        print("Запускаем исполняемый файл программы");
    }
}
 
///ConcreteImplementorB
struct SwiftLanguage : Language{
    func Build(){
        print("С помощью компилятора Apple LLVM компилируем исходный код");
    }
 
    func Execute(){
        print("Запускаем .ipa файл");
    }
}
 
///Abstraction
protocol Programmer{
    var language: Language { get set }
    func doWork()
    func earnMoney()
}

extension Programmer{
    func doWork(){
        self.language.Build()
        self.language.Execute()
    }
}

///RefinedAbstraction
struct FreelanceProgrammer: Programmer{
    var language: Language
    
    func earnMoney() {
        print("Получаем оплату за выполненный заказ")
    }
}

///RefinedAbstraction
struct CorporateProgrammer : Programmer{
    var language: Language
    
    func earnMoney() {
        print("Получаем в конце месяца зарплату");
    }
}

// создаем нового программиста, он работает с с++
var freelancer: Programmer = FreelanceProgrammer(language: CPPLanguage());
freelancer.doWork()
freelancer.earnMoney()

// пришел новый заказ, но теперь нужен swift
freelancer.language = SwiftLanguage();
freelancer.doWork();
freelancer.earnMoney();

//:  ## _Composite_
//: ### Компоновщик — это структурный паттерн проектирования, который позволяет сгруппировать множество объектов в древовидную структуру, а затем работать с ней так, как будто это единичный объект.
//: Паттерн Компоновщик (Composite) объединяет группы объектов в древовидную структуру по принципу "часть-целое и позволяет клиенту одинаково работать как с отдельными объектами, так и с группой объектов.
//:
//: Паттерн Компоновщик имеет смысл только тогда, когда основная модель вашей программы может быть структурирована в виде дерева.
//:
//: Например, есть два объекта: Продукт и Коробка. Коробка может содержать несколько Продуктов и других Коробок поменьше. Те, в свою очередь, тоже содержат либо Продукты, либо Коробки и так далее.
//: ### Участники
//: * Component: определяет интерфейс для всех компонентов в древовидной структуре
//: * Composite: представляет компонент, который может содержать другие компоненты и реализует механизм для их добавления и удаления
//: * Leaf: представляет отдельный компонент, который не может содержать другие компоненты
//: * Client: клиент, который использует компоненты
//:
//: [Более подробно](https://refactoring.guru/ru/design-patterns/composite) и [тут](https://metanit.com/sharp/patterns/4.4.php)

///Component
protocol Vehicle{
    mutating func drive()
}

///Leaf
struct Car: Vehicle{
    mutating func drive(){
        print("Drive car")
    }
}

struct Truck: Vehicle{
    mutating func drive(){
        print("Drive truck")
    }
}

struct Bus: Vehicle{
    mutating func drive(){
        print("Drive bus")
    }
}

///Composite
struct CarPark: Vehicle{
    private var vehicles = [Vehicle]()
    
    init(vehicles: Vehicle...){
        self.vehicles = vehicles
    }
    
    mutating func drive(){
        for var vehicle in self.vehicles{
            vehicle.drive()
        }
    }
}

var carPark = CarPark(vehicles: Bus(), Truck(), Car())
carPark.drive()

//:  ## _Decorator_
//: ### Декоратор — это структурный паттерн проектирования, который позволяет динамически добавлять объектам новую функциональность, оборачивая их в полезные «обёртки».
//: Для определения нового функционала в классах нередко используется наследование. Декораторы же предоставляет наследованию более гибкую альтернативу, поскольку позволяют динамически в процессе выполнения определять новые возможности у объектов.
//: ### Участники
//: * Component: абстрактный класс, который определяет интерфейс для наследуемых объектов
//: * ConcreteComponent: конкретная реализация компонента, в которую с помощью декоратора добавляется новая функциональность
//: * Decorator: собственно декоратор, реализуется в виде абстрактного класса и имеет тот же базовый класс, что и декорируемые объекты. Поэтому базовый класс Component должен быть по возможности легким и определять только базовый интерфейс. Класс декоратора также хранит ссылку на декорируемый объект в виде объекта базового класса Component и реализует связь с базовым классом как через наследование, так и через отношение агрегации.
//: * Классы ConcreteDecoratorA и ConcreteDecoratorB представляют дополнительные функциональности, которыми должен быть расширен объект ConcreteComponent.
//:
//: [Более подробно](https://refactoring.guru/ru/design-patterns/decorator) и [тут](https://metanit.com/sharp/patterns/4.1.php)

///Component
protocol Pizza{
    var name: String { get }
    func getCost() -> Int
}
 
///ConcreteComponent
struct ItalianPizza: Pizza{
    var name: String
    func getCost() -> Int{
        return 10
    }
    init(){
        self.name = "Итальянская пицца"
    }
}

///ConcreteComponent
struct BulgerianPizza: Pizza{
    var name: String
    func getCost() -> Int{
        return 8
    }
    init(){
        self.name = "Болгарская пицца"
    }
}

///Decorator
protocol PizzaDecorator : Pizza{
    var pizza: Pizza { get }
    func getCost() -> Int
}

///ConcreteDecoratorA
struct TomatoPizza : PizzaDecorator{
    
    var name: String{
        return self.pizza.name + " с томатами"
    }
    
    let pizza: Pizza
    
    func getCost() -> Int{
        return pizza.getCost() + 3;
    }
}

///ConcreteDecoratorB
struct CheesePizza : PizzaDecorator{
    let pizza: Pizza
    
    var name: String{
        return self.pizza.name + " с сыром"
    }
    
    func getCost() -> Int{
        return pizza.getCost() + 5;
    }
}

var pizza1: Pizza = ItalianPizza();
pizza1 = TomatoPizza(pizza: pizza1); // итальянская пицца с томатами
print("Name: \(pizza1.name), price: \(pizza1.getCost())")

var pizza2: Pizza = ItalianPizza();
pizza2 = CheesePizza(pizza: pizza2);// итальянская пиццы с сыром
print("Name: \(pizza2.name), price: \(pizza2.getCost())")

var pizza3: Pizza = BulgerianPizza();
pizza3 = TomatoPizza(pizza: pizza3);
pizza3 = CheesePizza(pizza: pizza3);// болгарская пиццы с томатами и сыром
print("Name: \(pizza3.name), price: \(pizza3.getCost())")

//:  ## _Facade_
//: ### Фасад — это структурный паттерн проектирования, который предоставляет простой интерфейс к сложной системе классов, библиотеке или фреймворку.
//: Когда использовать фасад?
//: * Когда имеется сложная система, и необходимо упростить с ней работу. Фасад позволит определить одну точку взаимодействия между клиентом и системой.
//: * Когда надо уменьшить количество зависимостей между клиентом и сложной системой. Фасадные объекты позволяют отделить, изолировать компоненты системы от клиента и развивать и работать с ними независимо.
//: * Когда нужно определить подсистемы компонентов в сложной системе. Создание фасадов для компонентов каждой отдельной подсистемы позволит упростить взаимодействие между ними и повысить их независимость друг от друга.
//: ### Участники
//: * Классы SubsystemA, SubsystemB, SubsystemC и т.д. являются компонентами сложной подсистемы, с которыми должен взаимодействовать клиент
//: * Client взаимодействует с компонентами подсистемы
//: * Facade - непосредственно фасад, который предоставляет интерфейс клиенту для работы с компонентами
//:
//: [Более подробно](https://refactoring.guru/ru/design-patterns/facade) и [тут](https://metanit.com/sharp/patterns/4.3.php)

///SubsystemA
struct FrontEndCompileStage{
    func parse(){
        print("Парсить код и строить абстрактное дерево - abstract semantic tree (AST)")
    }
    
    func sema(){
        print("Провести семантический анализ")
    }
    
    func silGen(){
        print("Сгенерировать SIL - Swift Intermediate Language")
    }
}

///SubsystemB
struct MiddleEndCompilerStage{
    
    func silOptimize(){
        print("Провести оптимизацию SIL")
    }
    
    func irGen(){
        print("Сгенерировать промежуточное представление для LLVM")
    }
}

///SubsystemC
struct BackEndComplilerStage{
    func codeGenerate(){
        print("Сгенерировать ассембли код и моздать исполняемый файл")
    }
}

///Facade
struct CompilerFacade{
    let front: FrontEndCompileStage
    let middle: MiddleEndCompilerStage
    let back: BackEndComplilerStage
    
    func compile(){
        front.parse()
        front.sema()
        front.silGen()
        middle.silOptimize()
        middle.irGen()
        back.codeGenerate()
    }
}

///Client
struct Xcode{
    func compileApp(compiler: CompilerFacade){
        compiler.compile()
    }
}

let xcode = Xcode()
xcode.compileApp(compiler: CompilerFacade(front: FrontEndCompileStage(), middle: MiddleEndCompilerStage(), back: BackEndComplilerStage()))

//:  ## _Proxy_
//: ### Заместитель — это структурный паттерн проектирования, который позволяет подставлять вместо реальных объектов специальные объекты-заменители. Эти объекты перехватывают вызовы к оригинальному объекту, позволяя сделать что-то до или после передачи вызова оригиналу.
//: Когда использовать прокси?
//: * Когда надо осуществлять взаимодействие по сети, а объект-проси должен имитировать поведения объекта в другом адресном пространстве. Использование прокси позволяет снизить накладные издержки при передачи данных через сеть. Подобная ситуация еще называется удалённый заместитель (remote proxies)
//: * Когда нужно управлять доступом к ресурсу, создание которого требует больших затрат. Реальный объект создается только тогда, когда он действительно может понадобится, а до этого все запросы к нему обрабатывает прокси-объект. Подобная ситуация еще называется виртуальный заместитель (virtual proxies)
//: * Когда необходимо разграничить доступ к вызываемому объекту в зависимости от прав вызывающего объекта. Подобная ситуация еще называется защищающий заместитель (protection proxies)
//: * Когда нужно вести подсчет ссылок на объект или обеспечить потокобезопасную работу с реальным объектом. Подобная ситуация называется "умные ссылки" (smart reference)
//: ### Участники
//: * Subject: определяет общий интерфейс для Proxy и RealSubject. Поэтому Proxy может использоваться вместо RealSubject
//: * RealSubject: представляет реальный объект, для которого создается прокси
//: * Proxy: заместитель реального объекта. Хранит ссылку на реальный объект, контролирует к нему доступ, может управлять его созданием и удалением. При необходимости Proxy переадресует запросы объекту RealSubject
//: * Client: использует объект Proxy для доступа к объекту RealSubject
//:
//: [Более подробно](https://refactoring.guru/ru/design-patterns/facade) и [тут](https://metanit.com/sharp/patterns/4.3.php)

//: ### Protection proxy example:

///Subject
protocol DoorOpening {
    func open(doors: String) -> String
}

///RealSubject
final class HAL9000: DoorOpening {
    func open(doors: String) -> String {
        return ("HAL9000: Affirmative, Dave. I read you. Opened \(doors).")
    }
}

///Proxy
final class CurrentComputer: DoorOpening {
    private var computer: HAL9000!

    func authenticate(password: String) -> Bool {

        guard password == "pass" else {
            return false
        }

        computer = HAL9000()

        return true
    }

    func open(doors: String) -> String {

        guard computer != nil else {
            return "Access Denied. I'm afraid I can't do that."
        }

        return computer.open(doors: doors)
    }
}

let computer = CurrentComputer()
let podBay = "Pod Bay Doors"

print(computer.open(doors: podBay))

computer.authenticate(password: "pass")
print(computer.open(doors: podBay))

//: ### Virtual proxy example:

///Subject
protocol HEVSuitMedicalAid {
    func administerMorphine() -> String
}

///RealSubject
final class HEVSuit: HEVSuitMedicalAid {
    func administerMorphine() -> String {
        return "Morphine administered."
    }
}

///Proxy
final class HEVSuitHumanInterface: HEVSuitMedicalAid {

    lazy private var physicalSuit: HEVSuit = HEVSuit()

    func administerMorphine() -> String {
        return physicalSuit.administerMorphine()
    }
}

let humanInterface = HEVSuitHumanInterface()
print(humanInterface.administerMorphine())

//:  ## _Flyweight_
//: ### Легковес — это структурный паттерн проектирования, который позволяет вместить бóльшее количество объектов в отведённую оперативную память. Легковес экономит память, разделяя общее состояние объектов между собой, вместо хранения одинаковых данных в каждом объекте.
//: Когда использовать легковес?
//: * Когда приложение использует большое количество однообразных объектов, из-за чего происходит выделение большого количества памяти
//: * Когда часть состояния объекта, которое является изменяемым, можно вынести во вне. Вынесение внешнего состояния позволяет заменить множество объектов небольшой группой общих разделяемых объектов.
//: ### Участники
//: * Flyweight: определяет интерфейс, через который приспособленцы-разделяемые объекты могут получать внешнее состояние или воздействовать на него
//: * ConcreteFlyweight: конкретный класс разделяемого приспособленца. Реализует интерфейс, объявленный в типе Flyweight, и при необходимости добавляет внутреннее состояние. Причем любое сохраняемое им состояние должно быть внутренним, не зависящим от контекста
//: * UnsharedConcreteFlyweight: еще одна конкретная реализация интерфейса, определенного в типе Flyweight, только теперь объекты этого класса являются неразделяемыми
//: * FlyweightFactory: фабрика приспособленцев - создает объекты разделяемых приспособленцев. Так как приспособленцы разделяются, то клиент не должен создавать их напрямую. Все созданные объекты хранятся в пуле. В примере выше для определения пула используется объект Hashtable, но это не обязательно. Можно применять и другие классы коллекций. Однако в зависимости от сложности структуры, хранящей разделяемые объекты, особенно если у нас большое количество приспособленцев, то может увеличиваться время на поиск нужного приспособленца - наверное это один из немногих недостатков данного паттерна. Если запрошенного приспособленца не оказалось в пуле, то фабрика создает его.
//: * Client: использует объекты приспособленцев. Может хранить внешнее состояние и передавать его в качестве аргументов в методы приспособленцев
//:
//: [Более подробно](https://refactoring.guru/ru/design-patterns/facade) и [тут](https://metanit.com/sharp/patterns/4.3.php)

protocol House{
    var stages: Int { get } // количество этажей
 
    func build(longitude: Double,latitude: Double)
}
 
struct PanelHouse : House{
    var stages: Int
    
    func build(longitude: Double, latitude: Double) {
        print("Построен панельный дом из 16 этажей; координаты: \(longitude) широты и \(latitude) долготы")
    }
    
    init(){
        self.stages = 16
    }
}

struct BrickHouse : House{
    var stages: Int
    init(){
        self.stages = 5
    }
 
    func build(longitude: Double, latitude: Double) {
        print("Построен кирпичный дом из 5 этажей; координаты: \(longitude) широты и \(latitude) долготы")
    }
}
 
class HouseFactory{
    private var houses: [String: House] = [:]
    
    init(){
        houses["Panel"] = PanelHouse()
        houses["Brick"] = BrickHouse()
    }
 
    func getHouse(key: String)-> House? {
        guard houses.index(forKey: key) != nil else {return nil}
        return houses[key]
    }
}

var longitude = 37.61
var latitude = 55.74

var houseFactory =  HouseFactory()
for _ in 1...5 {

    let panelHouse = houseFactory.getHouse(key: "Panel")
    if (panelHouse != nil){
        panelHouse!.build(longitude: longitude, latitude: latitude)
        longitude += 0.1
        latitude += 0.1
    }
}

for _ in 1...5{
    let brickHouse = houseFactory.getHouse(key: "Brick")
    if (brickHouse != nil){
        brickHouse!.build(longitude: longitude, latitude: latitude)
        longitude += 0.1
        latitude += 0.1
    }
}

//:
//: [к содержанию](Intro)
//:
//: [к порождающим паттернам](CreationalPatterns)
//:
//: [к поведенеческим паттернам](BehavioralPatterns)
//:
