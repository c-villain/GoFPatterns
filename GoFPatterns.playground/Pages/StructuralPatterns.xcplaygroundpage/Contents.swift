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


//: [к содержанию](Intro)
//:
//: [к порождающим паттернам](CreationalPatterns)
//:
//: [к поведенеческим паттернам](BehavioralPatterns)
//:
