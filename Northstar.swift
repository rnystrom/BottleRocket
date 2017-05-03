class MyObject {
    let name: String

    init?(json: [String: Any]) {
        guard let name = json["name"] as? String else { return nil }
        self.name = name
    }
}

final class Northstar: NSCoding {

    struct Keys {
        static let name = "name"
        static let objects = "objects"
        static let count = "count"
    }

    let name: String
    let objects: [MyObject]
    let object: MyObject
    let count: Int?

    init(
        name: String,
        objects: [MyObject],
        object: MyObject,
        count: Int?
        ) {
        self.name = name
        self.objects = objects
        self.object = object
        self.count = count
    }

    convenience init?(json: [String: Any]?) {
        guard let json = json else { return nil }
        // ?(guard )let NAME = json[Keys.NAME] as? TYPE?( else { return nil })

        guard let name = json[Keys.name] as? String else { return nil }
        guard let strings = json[Keys.objects] as? [String] else { return nil }

        guard let objectJSON = json[Keys.object] as? [String: Any] else { return nil }
//        let objectJSON = json[Keys.object] as? [String: Any]
        //

        guard let objectDicts = json[Keys.objects] as? [ [String: Any] ] else { return nil }
        var objects = [MyObject]()
        for dict in objectDicts {
            if let object = MyObject(json: dict) {
                objects.append(object)
            }
        }

        let count = json[Keys.count] as? Int

        self.init(
            name: name,
            objects: objects,
            count: count
        )
    }

    convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: Keys.name) as? String else { return nil }
        guard let objects = aDecoder.decodeObject(forKey: Keys.objects) as? [MyObject] else { return nil }

        let count = aDecoder.decodeInteger(forKey: Keys.count)
        self.init(
            name: name,

            objects: objects,
            count: count
        )
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Keys.name)
        aCoder.encode(objects, forKey: Keys.objects)
        aCoder.encode(count, forKey: Keys.count)
    }

}