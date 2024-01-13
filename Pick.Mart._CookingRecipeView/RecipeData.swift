//
//  RecipeData.swift
//  Pick.Mart._CookingRecipeView
//
//  Created by 金山義成 on 2024/01/13.
//

import SwiftUI


//レシピ構造体
struct Recipe: Equatable, Codable, Hashable, Identifiable{
    //レシピID
    var id: String = ""
    //レシピタイトル
    var name: String = ""
    //レシピURL(該当SNSページに飛ぶ)
    var url: String = ""
    //4けた番号。番号検索で用いる
    var number: String = ""
    //画像
    var image: String = ""
    
    //調味料データ
    //調味料タイトル
    var spices: [String] = []
    //調味料ID
    var spiceId: [String] = []
    //調味料の単位(大さじ、小さじなど)
    var unitofspices: [String] = []
    //調味料の量
    var quantityofspices: [String] = []
    //調味料のタイプ(★や⚫︎、▲など)
    var typeofspices: Array<String> = []
    //調味料の小数の桁数(0.5なら1、0.25なら2)
    var numberofdigitsofspices: Array<Int> = []
    
    //食材データ
    //食材タイトル
    var materials: Array<String> = []
    //食材ID
    var materialsId: Array<String> = []
    //食材の単位(本、個、cmなど)
    var unitofmaterials: Array<String> = []
    //食材の量(1本なら1、10個なら10)
    var quantityofmaterials: Array<String> = []
    //食材のグラム量
    var gramquantityofmaterials: Array<String> = []
    //食材の小数の桁数(0.5なら1、0.25なら2)
    var numberofdigitsofmaterials: Array<Int> = []
    
    //調理工程
    var process: Array<String> = []
    //調理時間
    var time: String = ""
    
    //レシピタイプ(主菜か副菜か、、)
    var type: String = ""
    
    //レシピジャンル(和食か中華か洋食か、、)
    var genre: String = ""
    
    //安いレシピ
    var cheap: Bool = false
    //簡単レシピ
    var easy: Bool = false
    //時短レシピ
    var speedy: Bool = false
    //健康レシピ
    var healthy: Bool = false
    //レンチンのみレシピ
    var onlymicrowave: Bool = false
    //一手間レシピ
    var onepoint: Bool = false
    //基本・定番レシピ
    var basic: Bool = false
    //野菜たっぷりレシピ
    var vegetably: Bool = false
    
    //カロリー
    var calorie: String = ""
    //タンパク質
    var protein: String = ""
    //炭水化物
    var carbohydrates: String = ""
    //塩分
    var salt: String = ""
    //脂質
    var lipid: String = ""
    
    //検索ワードstr
    var searchword: String = ""
    //検索ワードarr
    var searchwordArr: [String] = []
    
    //献立作成に含ませられるか
    var available: Bool = false
    
    //閲覧数
    var numberofViews: Int = 0
    //お気に入り数
    var numberofFavorite: Int = 0
    
    //作成者
    var madeBy: String = ""
    
    //表示可能か
    var appearing: Bool = true
    
    //作成日
    var date: Double = 0.0
    
    //消された献立フラグ
    var deleted: Bool = false
}

//食材
struct Material: Equatable, Codable, Hashable, Identifiable{
    //ID
    var id: String = UUID().uuidString
    //タイトル
    var name: String = ""
    //サーチワードStr
    var searchwords: String = ""
    //サーチワードArr
    var searchwordsArr: [String] = []
    //すべての単位(例：ねぎ→本、cm、g)
    var units: [String] = []
    //それぞれの単位のスーパーで買えるもっとも少ない量の重さ
    var minQuantityOfUnits: [String] = []
    //それぞれの単位が1の量の時の重さ
    var quantityOfUnits: [String] = []
    //0:青果
    //1:肉類
    //2:魚類
    //3:その他
    var type: Int = 0
}

//調味料
struct Spice: Hashable, Codable, Equatable{
    var id: String = ""
    var name: String = ""
    var searchWords: String = ""
    var searchwordsArr: [String] = []
    //持っている前提の調味料(醤油、塩、みりんなど)
    var defaultSpice = false
    //買える調味料(茹で汁とかはfalse)
    var canBuy:Bool = true
    
}

//シェフ構造体
struct ChefData:  Equatable, Codable, Hashable{
    //ID
    var id: String = ""
    //名前
    var name: String = ""
    //画像
    var image: String = ""
    //特定のURL(インスタアカウントURLなど)
    var url: String = ""
    
    //作ってる献立タグ
    //安
    var cheap: Bool = false
    //楽
    var easy: Bool = false
    //時短
    var speedy: Bool = false
    //ヘルシー
    var healthy: Bool = false
}

//ユーザーデータ
struct UserData: Equatable ,Codable{
//    var id: String = ""
//    var date: Date = Date()
//    var password: String = ""
//    var name: String = ""
    
//    var allergies: [Allergie] = []
//    var havingSpices: [Spice] = []
    
    //今回使うのはこれだけ
    //閲覧したレシピ
    var lookedRecipesStr: [String] = []
    //お気に入りしたレシピ
    var favoriteRecipesStr: [String] = []
    //何人前か
    var numberOfPeople: Double = 1.0
    
//    var favoriteDecidedRecipes: [[String]] = []
//    var decidedRecipes:[DecidedRecipes] = []
//    var searchWords: [String] = []
//    var shoppingList: ShoppingList = ShoppingList()
//    var havingMaterials: [Materials] = []
//    var recommendChef:[ChefData] = []
//    var mustLoadRecipe: Bool = false
//    var typeRecipe:Int = 0
//    var developer:Bool = false
//    var chef:Bool = false
//    var lookedWelcomeView = false
    
}



class RecipeData:ObservableObject{
    //レシピデータ
    @Published var cookingRecipes:[Recipe] = Bundle.main.decodeJSON("Recipes.json")
    //材料データ
    @Published var materials:[Material] = Bundle.main.decodeJSON("Materials.json")
    //調味料データ
    @Published var spices:[Spice] = Bundle.main.decodeJSON("Spices.json")
    //シェフデータ(便宜上、製作者のみ。想定は特定のSNSの献立アカウント)
    @Published var chefs:[ChefData] = [
        ChefData(
            id: "r9UWgPO65pUIcvkxQYTlIppy5ph1",
            name: "yoshinariキッチン",
            image: "https://lh3.googleusercontent.com/pw/ABLVV84OIHBAQb4HQ56m2ns5YVLZRXPV_kzQTxd-5jcm6LdqZXJcI8s10SxahnaRlAB5OS8jgOK1X0WuB1oLiV8Twv0PriBsvUuOcE9gT3gFAMdDIO0ZL3UlDaeq03Y6C3Js2s2ll5sj6kFmqBI-MjuNwcRaQg",
            url: "https://www.instagram.com/10_yoshinari",
            cheap: false,
            easy: false,
            speedy: false,
            healthy: false
        )
    ]
    //ユーザーデータ
    @Published var userData:UserData = UserData(
        lookedRecipesStr: [],
        favoriteRecipesStr: ["2022C58B-EACE-4194-995A-D7D24C8DECE2"],
        numberOfPeople: 2
    )
}


