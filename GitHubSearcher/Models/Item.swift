struct Item: Codable {
    let id: Int
    let name: String
    let stargazersCount:Int
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case stargazersCount = "stargazers_count"
    }

    init(id: Int, name: String, stargazersCount:Int) {
        self.id = id
        self.name = name
        self.stargazersCount = stargazersCount
    }
}
