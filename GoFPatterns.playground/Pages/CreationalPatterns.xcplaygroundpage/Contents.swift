//: [к содержанию](Intro)
//:
//: [к структурным паттернам](StructuralPatterns)
//:
//: [к поведенеческим паттернам](BehavioralPatterns)
import Foundation
//: # _Порождающие паттерны_
//:
//:  ## _Factory Method_
//: ### Фабричный метод — это порождающий паттерн проектирования, который определяет общий интерфейс для создания объектов в суперклассе, позволяя подклассам изменять тип создаваемых объектов.
//: [Более подробно](https://refactoring.guru/ru/design-patterns/factory-method)
//:
protocol Drivable{
    func Drive()
}

class Car: Drivable{
    func Drive(){
        print("Drive car!")
    }
}

class Track: Drivable{
    func Drive(){
        print("Drive track!")
    }
}

class Bus: Drivable{
    func Drive(){
        print("Drive bus!")
    }
}

enum Vehicle{
    case BMWx5
    case KAMAZ
    case MercedesTourismo
}

enum VehicleFactory{
    static func drive(for car: Vehicle) -> Drivable {
        switch car{
        case .BMWx5:
            return Car()
        case .KAMAZ:
            return Track()
        case .MercedesTourismo:
            return Bus()
        }
    }
}
(VehicleFactory.drive(for: .BMWx5) as Drivable).Drive()
(VehicleFactory.drive(for: .KAMAZ) as Drivable).Drive()
(VehicleFactory.drive(for: .MercedesTourismo) as Drivable).Drive()

//:  ## _Abstract Factory_
//: ### Абстрактная фабрика — это порождающий паттерн проектирования, который позволяет создавать семейства связанных объектов, не привязываясь к конкретным классам создаваемых объектов.
//: [Более подробно](https://refactoring.guru/ru/design-patterns/abstract-factory)

protocol VehicleDrivable{
    func Drive()
}

class BMWCars: VehicleDrivable{
    func Drive(){
        print("BMW driving")
    }
}

class MercedesCars: VehicleDrivable{
    func Drive(){
        print("Mercedes driving")
    }
}

protocol CarAbstractFactory{
    func CreateCar() -> VehicleDrivable
}

final class BMWFactory: CarAbstractFactory{
    func CreateCar() -> VehicleDrivable{
         return BMWCars()
    }
}

final class MercedesFactory: CarAbstractFactory{
    func CreateCar() -> VehicleDrivable{
        return MercedesCars()
    }
}

enum CarsFactoryType: CarAbstractFactory{
    case bmw
    case mercedes
    
    func CreateCar() -> VehicleDrivable{
        switch self{
        case .bmw:
            return BMWFactory().CreateCar()
            
        case .mercedes:
            return MercedesFactory().CreateCar()
        }
    }
}

CarsFactoryType.bmw.CreateCar().Drive()
CarsFactoryType.mercedes.CreateCar().Drive()

//:  ## _Prototype_
//: ### Прототип — это порождающий паттерн проектирования, который позволяет копировать объекты, не вдаваясь в подробности их реализации.
//: [Более подробно](https://refactoring.guru/ru/design-patterns/prototype)

protocol Prototype{
    associatedtype Object
    func clone() -> Object
}

struct Plane: Prototype{
    var name: String
    let wingspan: Double
    
    init(name: String, wingspan: Double){
        self.name = name
        self.wingspan = wingspan
    }
    
    func clone() -> Plane {
        return Plane(name: self.name, wingspan: self.wingspan)
    }
}

let il96_protype = Plane(name: "IL-96", wingspan: 60)

var il96_400 = il96_protype.clone()
il96_400.name += "-400"
print("\(il96_400)")

var il96_300 = il96_protype.clone()
il96_300.name += "-300"
print("\(il96_300)")

var il96_MD = il96_protype.clone()
il96_MD.name += "MD"
print("\(il96_MD)")

//:  ## _Builder_
//: ### Строитель — это порождающий паттерн проектирования, который позволяет создавать сложные объекты пошагово. Строитель даёт возможность использовать один и тот же код строительства для получения разных представлений объектов.
//: [Более подробно](https://refactoring.guru/ru/design-patterns/builder)
final class WallBuiler{
    var walls: String?
    typealias wallBuilderClosure = (WallBuiler) -> Void
    init (wallBuildClosure: (WallBuiler) -> Void){
        wallBuildClosure(self)
    }
}

final class WindowsBuiler{
    var windows: String?
    typealias windowsBuilderClosure = (WindowsBuiler) -> Void
    init (windowsBuildClosure: (WindowsBuiler) -> Void){
        windowsBuildClosure(self)
    }
}

class HouseBuilder{
    var walls: String?
    var windows: String?
    
    //опциональный иницилизатор
    init?(wallBuilder: WallBuiler?, windowsBuiler: WindowsBuiler?){
        if let walls = wallBuilder?.walls{
            self.walls = walls
        }
        if let windows = windowsBuiler?.windows{
            self.windows = windows
        }
    }
}

let wallbuilder = WallBuiler{
    wallBldr in wallBldr.walls = "Build walls"
}

let windowsBilder = WindowsBuiler{
    windowsBldr in windowsBldr.windows = "Build windows"
}

var house = HouseBuilder(wallBuilder: wallbuilder, windowsBuiler: windowsBilder)

print("Walls: \(String(describing: house?.walls)), windows: \(String(describing: house?.windows))")

//:  ## _Singletone_
//: ### Одиночка — это порождающий паттерн проектирования, который гарантирует, что у класса есть только один экземпляр, и предоставляет к нему глобальную точку доступа.
//: * Одиночка решает сразу две проблемы, нарушая принцип единственной ответственности класса. Гарантирует наличие единственного экземпляра класса. Чаще всего это полезно для доступа к какому-то общему ресурсу, например, базе данных.
//: * Предоставляет глобальную точку доступа. Это не просто глобальная переменная, через которую можно достучаться к определённому объекту. Глобальные переменные не защищены от записи, поэтому любой код может подменять их значения без вашего ведома.
//: Правительство государства — хороший пример одиночки. В государстве может быть только одно официальное правительство. Вне зависимости от того, кто конкретно заседает в правительстве, оно имеет глобальную точку доступа «Правительство страны N».
//:
//: [Более подробно](https://refactoring.guru/ru/design-patterns/singleton)

final class Singletone{
    static let shared = Singletone()
    private init(){
        //приватная инициализация для уверенности, что будет создан один инстанс класса
    }
}

let instance = Singletone.shared

//: [к содержанию](Intro)
//:
//: [к структурным паттернам](StructuralPatterns)
//:
//: [к поведенеческим паттернам](BehavioralPatterns)
//:
