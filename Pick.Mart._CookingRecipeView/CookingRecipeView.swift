//
//  CookingRecipeView.swift
//  Pick.Mart._CookingRecipeView
//
//  Created by 金山義成 on 2024/01/13.
//

import SwiftUI


struct CookingRecipeView: View {
    @EnvironmentObject var recipeData: RecipeData
    
    
    //ロード中フラグ
    @State var appearing = false

    //献立作成アクションシートフラグ
    @State var showingActionSheet = false

    //レシピ画面ロード中フラグ
    @State var imageAppearing = true

    //cookinRecipesのIndex
    @State var recipeNumber: Int = 0
    
    //何人分？
    @State var numberOfPeople:Double = 1.0
    
    //無効URLバナーopacity
    @State var opacityOfNotFoundUrl = 0.0
    
    
    //システムデータ
    //幅
    let widthOfPhone = UIScreen.main.bounds.size.width
    //高さ
    let heightOfPhone = UIScreen.main.bounds.size.height
    
    
    //食材の桁数の調整
    func setCookingRecipeData(cookingRecipes:[Recipe],allMaterials: [Material], numberOfPeople:Double) -> [Recipe]{
        var newCookingRecipes = recipeData.cookingRecipes
        
        
        for recipe in 0..<newCookingRecipes.count{
            //食材
            for material in 0..<newCookingRecipes[recipe].materialsId.count{
                //degitの調整
                if Int(Double(newCookingRecipes[recipe].quantityofmaterials[material])!*numberOfPeople*100) % 100 == 0{
                    newCookingRecipes[recipe].numberofdigitsofmaterials[material] = 0
                }
                else if Int(Double(newCookingRecipes[recipe].quantityofmaterials[material])!*numberOfPeople*100) % 10 == 0{
                    newCookingRecipes[recipe].numberofdigitsofmaterials[material] = 1
                }
                else{
                    newCookingRecipes[recipe].numberofdigitsofmaterials[material] = 2
                }
            }
            
            //調味料
            for spice in 0..<newCookingRecipes[recipe].spices.count{
                //degitの調整
                if Int(Double(newCookingRecipes[recipe].quantityofspices[spice])!*numberOfPeople*100) % 100 == 0{
                    newCookingRecipes[recipe].numberofdigitsofspices[spice] = 0
                }
                else{
                    newCookingRecipes[recipe].numberofdigitsofspices[spice] = 1
                }
            }
        }

        return newCookingRecipes

    }
    
    
    
    var body: some View {
        
        ZStack{
            VStack(spacing:0){
                TabView(selection: $recipeNumber){
                    ForEach(0..<recipeData.cookingRecipes.count, id:\.self){ i in
                        
                        //ロード完了
                        if appearing{
                            ZStack{
                                
                                //削除フラグが立ってなかったら表示
                                if !recipeData.cookingRecipes[i].deleted{
                                    ScrollView(showsIndicators:false){
                                        //画像
                                        //画像ロード完了
                                        if imageAppearing{
                                            AsyncImage(url: URL(string: recipeData.cookingRecipes[i].image)) { phase in
                                                if let image = phase.image {
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: widthOfPhone, height:widthOfPhone)
                                                        .clipped()
                                                } else if let error = phase.error {
                                                    //読込失敗したら、再読込み呼びかけ
                                                    Button(action:{
                                                        imageAppearing = false
                                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.25){
                                                            imageAppearing = true
                                                        }
                                                    }){
                                                        VStack(spacing:2){
                                                            Image(systemName:"arrow.clockwise")
                                                                .font(.title)
                                                            Text("再読込")
                                                                .font(.caption2)
                                                        }
                                                    }
                                                    .foregroundStyle(.gray)
                                                } else {
                                                    ProgressView()
                                                        .frame(width: widthOfPhone, height:widthOfPhone)
                                                }
                                            }
                                            .frame(width: widthOfPhone, height:widthOfPhone)
                                        }
                                        //画像ロード中
                                        else{
                                            ProgressView()
                                                .frame(width: widthOfPhone, height:widthOfPhone)
                                        }


                                        VStack{
                                            //シェフとお気に入りハート
                                            //シェフが作った献立の場合
                                            if recipeData.chefs.contains(where: {$0.id == recipeData.cookingRecipes[i].madeBy}){
                                                HStack{
                                                    Button(action:{
                                                        if let url = URL(string:recipeData.chefs.first(where: {$0.id == recipeData.cookingRecipes[i].madeBy})!.url) {
                                                            UIApplication.shared.open(url, options: [.universalLinksOnly: false], completionHandler: {completed in
                                                                //成功
                                                                if completed{
                                                                    print("成功")
                                                                }
                                                                //失敗
                                                                else{
                                                                    print("失敗")
                                                                    //無効URLバナー表示
                                                                    withAnimation(){
                                                                        opacityOfNotFoundUrl = 0.8
                                                                    }
                                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                                        withAnimation(){
                                                                            opacityOfNotFoundUrl = 0
                                                                        }
                                                                    }
                                                                }
                                                            })
                                                        }
                                                    }){
                                                        HStack{
                                                            
                                                            //シェフ画像
                                                            AsyncImage(url: URL(string: recipeData.chefs.first(where: {$0.id == recipeData.cookingRecipes[i].madeBy})!.image)) { phase in
                                                                //成功
                                                                if let image = phase.image {
                                                                    ZStack(alignment:.top){
                                                                        image
                                                                            .resizable()
                                                                            .scaledToFill()
                                                                            .frame(width:40,height:40)
                                                                            .clipShape(Circle())
                                                                    }
                                                                    .frame(width:40,height:40)
                                                                } 
                                                                //失敗
                                                                else if phase.error != nil {
                                                                    ZStack{
                                                                        Circle()
                                                                            .stroke(lineWidth: 1)
                                                                            .foregroundColor(Color("subcolor"))
                                                                    }
                                                                    .frame(width:40,height:40)
                                                                } 
                                                                //ロード中
                                                                else {
                                                                    ZStack{
                                                                        Circle()
                                                                            .stroke(lineWidth: 1)
                                                                            .foregroundColor(Color("subcolor"))
                                                                        ProgressView()
                                                                    }
                                                                    .frame(width:40,height:40)
                                                                }
                                                            }
                                                            .frame(width:40,height:40)
                                                            Text(recipeData.chefs.first(where: {$0.id == recipeData.cookingRecipes[i].madeBy})!.name)
                                                                .bold()
                                                                .foregroundColor(.black)
                                                        }
                                                    }
                                                    Spacer()
                                                    Button(action:{
                                                        //ログアウト時はログイン導線

                                                        //お気に入りレシピに入ってたら、レシピidを消す
                                                        //入っていなかったら、レシピidを入れる
                                                        if recipeData.userData.favoriteRecipesStr.contains(recipeData.cookingRecipes[i].id){
                                                            recipeData.userData.favoriteRecipesStr
                                                                .removeAll(where: {$0 == recipeData.cookingRecipes[i].id})
                                                        }
                                                        else{
                                                            recipeData.userData.favoriteRecipesStr.append(recipeData.cookingRecipes[i].id)
                                                            //GoogleAnalytics
//                                                            Analytics.logEvent("Favorite_Recipes", parameters: [
//                                                                "userID": systemData.recipeData.userData.id != "" ? systemData.recipeData.userData.id : "ゲスト",
//                                                                "favoriteRecipe": recipeData.cookingRecipes[i].id,
//                                                                "date": dateFomrmatter.string(from: Date())
//                                                            ])

                                                        }


                                                    }){
                                                        if recipeData.userData.favoriteRecipesStr.contains(recipeData.cookingRecipes[i].id){
                                                            Image(systemName: "heart.fill")
                                                                .font(.largeTitle)
                                                                .foregroundColor(.pink)

                                                        }
                                                        else{
                                                            Image(systemName: "heart")
                                                                .font(.largeTitle)
                                                                .foregroundColor(.gray)
                                                        }
                                                    }
                                                }.padding(.vertical,5)
                                            }

                                            //公式が作った献立の場合
                                            //調理時間、カロリー
                                            HStack{
                                                //時間
                                                if recipeData.cookingRecipes[i].time != ""{
                                                    ZStack{
                                                        Circle()
                                                            .foregroundColor(Color("primaryColor"))
                                                            .frame(width:25)
                                                        Image(systemName: "clock")
                                                            .font(.body)
                                                            .foregroundColor(.white)
                                                            .bold()

                                                    }
                                                    Text("約"+recipeData.cookingRecipes[i].time+"分")
                                                        .font(.title3)
                                                        .padding(.trailing)
                                                }
                                                //カロリー
                                                if recipeData.cookingRecipes[i].calorie != ""{
                                                    ZStack{
                                                        Circle()
                                                            .foregroundColor(Color("primaryColor"))
                                                            .frame(width:25)
                                                        Image(systemName: "flame")
                                                            .font(.body)
                                                            .foregroundColor(.white)
                                                            .bold()

                                                    }
                                                    Text("約"+recipeData.cookingRecipes[i].calorie+"kcal /人")
                                                        .font(.title3)
                                                        .padding(.trailing)
                                                }
                                                Spacer()
                                                
                                                //ハート
                                                if !recipeData.chefs.contains(where: {$0.id == recipeData.cookingRecipes[i].madeBy}){
                                                    Button(action:{
                                                        
                                                        //ログアウト時はログイン導線
                                                        
                                                        //お気に入りレシピに入ってたら、レシピidを消す
                                                        //入っていなかったら、レシピidを入れる
                                                        if recipeData.userData.favoriteRecipesStr.contains(recipeData.cookingRecipes[i].id){
                                                            recipeData.userData.favoriteRecipesStr
                                                                .removeAll(where: {$0 == recipeData.cookingRecipes[i].id})
                                                        }
                                                        else{
                                                            recipeData.userData.favoriteRecipesStr.append(recipeData.cookingRecipes[i].id)
                                                            //GoogleAnalytics
//                                                            Analytics.logEvent("Favorite_Recipes", parameters: [
//                                                                "userID": systemData.recipeData.userData.id != "" ? systemData.recipeData.userData.id : "ゲスト",
//                                                                "favoriteRecipe": recipeData.cookingRecipes[i].id,
//                                                                "date": dateFomrmatter.string(from: Date())
//                                                            ])

                                                        }

                                                    }){
                                                        if recipeData.userData.favoriteRecipesStr.contains(recipeData.cookingRecipes[i].id){
                                                            Image(systemName: "heart.fill")
                                                                .font(.largeTitle)
                                                                .foregroundColor(.pink)

                                                        }
                                                        else{
                                                            Image(systemName: "heart")
                                                                .font(.largeTitle)
                                                                .foregroundColor(.gray)
                                                        }
                                                    }.padding(.vertical,5)
                                                }
                                            }

                                            //材料、人数
                                            HStack{
                                                Text("材料")
                                                    .font(.title2)
                                                    .bold()
                                                Spacer()
                                                HStack(spacing:0){
                                                    Text(String(format: "%.0f", numberOfPeople))
                                                    Text("人分")
                                                }.font(.title2)
                                                    .bold()

                                                if numberOfPeople > 1{
                                                    Button(action:{
                                                        //ログアウト時はログイン導線
//                                                        if systemData.recipeData.userData.id == ""{
//                                                            showingMustLogInView = true
//                                                            systemData.numberOfServicesTab = 2
//                                                        }
//                                                        else{
                                                        
                                                        
                                                            if numberOfPeople > 1{
                                                                numberOfPeople -= 1
                                                                
                                                                //recipeData.cookingRecipesのアップデート
                                                                recipeData.cookingRecipes = setCookingRecipeData(cookingRecipes: recipeData.cookingRecipes, allMaterials: recipeData.materials, numberOfPeople: numberOfPeople)
                                                                
                                                            }
//                                                        }
                                                    }){
                                                        ZStack{
                                                            RoundedRectangle(cornerRadius: 5)
                                                                .frame(width:40)
                                                                .foregroundColor(Color("primaryColor"))
                                                            RoundedRectangle(cornerRadius: 100)
                                                                .foregroundColor(.white)
                                                                .frame(width:17,height:4)
                                                        }
                                                    }
                                                }
                                                else{
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 5)
                                                            .stroke(lineWidth: 2)
                                                            .frame(width:40)
                                                            .foregroundColor(Color("subcolor"))
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .foregroundColor(Color("subcolor"))
                                                            .frame(width:17,height:4)
                                                    }
                                                }


                                                if numberOfPeople < 9{
                                                    Button(action:{
                                                        //ログアウト時はログイン導線
//                                                        if systemData.recipeData.userData.id == ""{
//                                                            showingMustLogInView = true
//                                                            systemData.numberOfServicesTab = 2
//                                                        }
//                                                        else{
                                                            if numberOfPeople < 9{
                                                                numberOfPeople += 1
                                                                //recipeData.cookingRecipesのアップデート
                                                                recipeData.cookingRecipes = setCookingRecipeData(cookingRecipes: recipeData.cookingRecipes, allMaterials: recipeData.materials, numberOfPeople: numberOfPeople)
                                                            }
//                                                        }
                                                    }){
                                                        ZStack{
                                                            RoundedRectangle(cornerRadius: 5)
                                                                .frame(width:40)
                                                                .foregroundColor(Color("primaryColor"))
                                                            RoundedRectangle(cornerRadius: 100)
                                                                .foregroundColor(.white)
                                                                .frame(width:17,height:4)
                                                            RoundedRectangle(cornerRadius: 100)
                                                                .foregroundColor(.white)
                                                                .frame(width:4,height:17)
                                                        }
                                                    }
                                                }
                                                else{
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 5)
                                                            .stroke(lineWidth:2)
                                                            .frame(width:40)
                                                            .foregroundColor(Color("subcolor"))
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .foregroundColor(Color("subcolor"))
                                                            .frame(width:17,height:4)
                                                        RoundedRectangle(cornerRadius: 100)
                                                            .foregroundColor(Color("subcolor"))
                                                            .frame(width:4,height:17)
                                                    }
                                                }
                                            }.padding(.leading,5)


                                            //食材、調味料、調理工程
                                            VStack(spacing:20){
                                                //食材View
                                                VStack(spacing:2){
                                                    HStack{
                                                        Text("[食材]")
                                                            .bold()
                                                        Spacer()
                                                    }

                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 5)
                                                            .foregroundColor(Color("subcolor2"))
                                                        VStack(spacing:7){
                                                            Rectangle()
                                                                .foregroundColor(Color("subcolor"))
                                                                .frame(height:1)
                                                                .opacity(0)
                                                            ForEach(0..<recipeData.cookingRecipes[i].materials.count, id:\.self){ material in
                                                                HStack{
                                                                    //名前
                                                                    Text(recipeData.cookingRecipes[i].materials[material])
                                                                        .font(.body)

                                                                    Spacer()

                                                                    //量
                                                                    if recipeData.cookingRecipes[i].unitofmaterials[material] != "g"{
                                                                        Text("(約"+String(format: "%.0f" ,Double(recipeData.cookingRecipes[i].gramquantityofmaterials[material])!*numberOfPeople)+"g)")
                                                                    }
                                                                    //単位
                                                                    Text(String(format: "%.\(recipeData.cookingRecipes[i].numberofdigitsofmaterials[material])f", Double(recipeData.cookingRecipes[i].quantityofmaterials[material])!*numberOfPeople)+recipeData.cookingRecipes[i].unitofmaterials[material])

                                                                }.padding(.horizontal,5)
                                                                
                                                                Rectangle()
                                                                    .foregroundColor(Color("subcolor"))
                                                                    .frame(height:1)
                                                                    .opacity(material < recipeData.cookingRecipes[i].materials.count-1 ? 0 : 1)
                                                            }
                                                        }.padding(.horizontal,10)
                                                    }
                                                }


                                                //調味料View
                                                VStack(spacing:2){
                                                    HStack{
                                                        Text("[調味料]")
                                                            .bold()
                                                        Spacer()
                                                    }

                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 5)
                                                            .foregroundColor(Color("subcolor2"))
                                                        VStack(spacing:7){
                                                            Rectangle()
                                                                .foregroundColor(Color("subcolor"))
                                                                .frame(height:1)
                                                                .opacity(0)
                                                            ForEach(0..<recipeData.cookingRecipes[i].spices.count, id:\.self){ spice in
                                                                HStack(spacing:1){
                                                                    //タイプ
                                                                    if recipeData.cookingRecipes[i].typeofspices[spice] != ""{
                                                                        Text(recipeData.cookingRecipes[i].typeofspices[spice])
                                                                    }
                                                                    
                                                                    //名前
                                                                    Text(recipeData.cookingRecipes[i].spices[spice])
                                                                        .font(.body)

                                                                    Spacer()
                                                                    
                                                                    //量と単位
                                                                    if recipeData.cookingRecipes[i].unitofspices[spice] == "大さじ" ||
                                                                        recipeData.cookingRecipes[i].unitofspices[spice] == "小さじ"
                                                                    {
                                                                        Text(recipeData.cookingRecipes[i].unitofspices[spice])
                                                                    }

                                                                    if recipeData.cookingRecipes[i].quantityofspices[spice] != "0"{
                                                                        Text(String(format: "%.\(recipeData.cookingRecipes[i].numberofdigitsofspices[spice])f", Double(recipeData.cookingRecipes[i].quantityofspices[spice])!*numberOfPeople))
                                                                    }

                                                                    if recipeData.cookingRecipes[i].unitofspices[spice] != "大さじ" &&
                                                                        recipeData.cookingRecipes[i].unitofspices[spice] != "小さじ"
                                                                    {
                                                                        Text(recipeData.cookingRecipes[i].unitofspices[spice])
                                                                    }
                                                                }

                                                                
                                                                Rectangle()
                                                                    .foregroundColor(Color("subcolor"))
                                                                    .frame(height:1)
                                                                    .opacity(spice < recipeData.cookingRecipes[i].spices.count-1 ? 0 : 1)

                                                            }
                                                        }.padding(.horizontal,10)
                                                    }
                                                }


                                                //調理工程View
                                                VStack(spacing:2){
                                                    HStack{
                                                        Text("[調理工程]")
                                                            .bold()
                                                        Spacer()
                                                    }

                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 5)
                                                            .foregroundColor(Color("subcolor2"))

                                                        if !recipeData.chefs.contains(where: {$0.id == recipeData.cookingRecipes[i].madeBy}) {
                                                            VStack(spacing:7){
                                                                Rectangle()
                                                                    .foregroundColor(Color("subcolor"))
                                                                    .frame(height:1)
                                                                    .opacity(0)
                                                                if recipeData.cookingRecipes[i].process.count > 0{
                                                                    ForEach(0..<recipeData.cookingRecipes[i].process.count, id:\.self){ process in
                                                                        HStack(spacing:0){
                                                                            HStack(alignment:.top,spacing:0){
                                                                                Text("\(process+1). ")
                                                                                    .font(.body)
                                                                                    .frame(width:25)
                                                                                Text(recipeData.cookingRecipes[i].process[process])
                                                                                    .lineLimit(nil)
                                                                                    .fixedSize(horizontal: false, vertical: true)
                                                                                    .font(.body)
                                                                            }

                                                                            Spacer()

                                                                        }.padding(.horizontal,5)

                                                                        
                                                                        Rectangle()
                                                                            .foregroundColor(Color("subcolor"))
                                                                            .frame(height:1)
                                                                            .opacity(process < recipeData.cookingRecipes[i].process.count-1 ? 1 : 0)
                                                                    }
                                                                }
                                                            }.padding(.horizontal,10)
                                                        }
                                                        else{
                                                            Button(action:{
                                                                if let url = URL(string:recipeData.cookingRecipes[i].url) {
                                                                    UIApplication.shared.open(url, options: [.universalLinksOnly: false], completionHandler: {completed in
                                                                        if completed{
                                                                            print("成功")
                                                                        }
                                                                        else{
                                                                            print("失敗")
                                                                            withAnimation(){
                                                                                opacityOfNotFoundUrl = 0.8
                                                                            }
                                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                                                withAnimation(){
                                                                                    opacityOfNotFoundUrl = 0
                                                                                }
                                                                            }
                                                                        }
                                                                    })
                                                                }
                                                            }){
                                                                HStack(spacing:2){
                                                                    Text("参照した献立のページを開く")
                                                                        .foregroundColor(.gray)
                                                                    Image(systemName:"paperplane.fill")
                                                                        .foregroundColor(Color("primaryColor"))
                                                                    Spacer()
                                                                }.padding(10)
                                                            }
                                                        }
                                                    }
                                                }

                                            }

                                        }.padding(.horizontal)
                                            .padding(.bottom)
                                        
                                        if recipeData.cookingRecipes[i].url != ""{
                                            Spacer()
                                                .frame(height:widthOfPhone/6)
                                                .padding()
                                        }
                                    }

                                    //URLにとぶ
                                    if recipeData.cookingRecipes[i].url != ""{
                                        VStack{
                                            Spacer()
                                            HStack{
                                                Spacer()
                                                Button(action: {
                                                    if let url = URL(string:recipeData.cookingRecipes[i].url) {
                                                        UIApplication.shared.open(url, options: [.universalLinksOnly: false], completionHandler: {completed in
                                                            if completed{
                                                                print("成功")
                                                            }
                                                            else{
                                                                print("失敗")
                                                                withAnimation(){
                                                                    opacityOfNotFoundUrl = 0.8
                                                                }
                                                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                                    withAnimation(){
                                                                        opacityOfNotFoundUrl = 0
                                                                    }
                                                                }
                                                            }
                                                        })
                                                    }

                                                }){
                                                    ZStack{
                                                        Circle()
                                                            .frame(width:widthOfPhone/6)
                                                            .foregroundColor(Color("primaryColor"))
                                                        Image(systemName: "paperplane.fill")
                                                            .resizable()
                                                            .frame(width:widthOfPhone/12, height:widthOfPhone/12)
                                                            .foregroundColor(.white)
                                                    }
                                                    .opacity(0.9)
                                                }
                                            }
                                            .padding(widthOfPhone/16)
                                        }
                                    }
                                }
                                
                                //削除フラグが立っていたいら非表示
                                else{
                                    Text("削除された献立")
                                }
                                
                                

                            }
                            .tag(i)
                            .frame(width: UIScreen.main.bounds.width)
                            .ignoresSafeArea(edges: [.bottom])
                        }
                        
                        //ロード中
                        else{
                            ProgressView()
                                .frame(width:widthOfPhone,height:heightOfPhone)
                        }
                    }

                }
                .animation(.default)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                //広告
                if appearing{
                    ZStack{
                        Rectangle()
                            .foregroundStyle(Color("subcolor"))
                        Text("AdMobの広告が表示される")
                    }
                    .frame(width: widthOfPhone, height: 75)
                }
                
//                献立を選ぶ
                if recipeData.cookingRecipes.count > 1{
                    VStack{
                        ZStack{
                            HStack{
                                ForEach(0..<recipeData.cookingRecipes.count, id:\.self){ i in

                                    if recipeData.cookingRecipes.count>3{
                                        Button(action:{
                                            withAnimation{
                                                recipeNumber = i
                                            }
                                        }){
                                            if i == recipeNumber{
                                                ZStack{
                                                    Circle()
                                                        .frame(width:widthOfPhone/12.5)
                                                        .foregroundColor(Color("primaryColor"))
                                                        .padding(.horizontal,3)
                                                    Text("\(i+1)")
                                                        .font(.title3)
                                                        .bold()
                                                        .foregroundColor(.white)
                                                }
                                            }else{
                                                ZStack{
                                                    Circle()
                                                        .stroke(lineWidth: 1)
                                                        .frame(width:widthOfPhone/12.5)
                                                        .foregroundColor(Color("primaryColor"))
                                                        .padding(.horizontal,3)
                                                    Text("\(i+1)")
                                                        .font(.title3)
                                                        .foregroundColor(Color("primaryColor"))
                                                }
                                            }
                                        }
                                    }
                                    else{
                                        Button(action:{
                                            withAnimation{
                                                recipeNumber = i
                                            }
                                        }){
                                            if recipeNumber == i{
                                                ZStack{
                                                    Capsule()
                                                        .frame(height:35)
                                                        .foregroundColor(Color("primaryColor"))
                                                    Text(recipeData.cookingRecipes[i].type)
                                                        .font(.title3)
                                                        .bold()
                                                        .foregroundColor(.white)
                                                }
                                            }
                                            else{
                                                ZStack{
                                                    Capsule()
                                                        .stroke(lineWidth:1)
                                                        .frame(height:35)
                                                        .foregroundColor(Color("primaryColor"))
                                                    Text(recipeData.cookingRecipes[i].type)
                                                        .font(.title3)
                                                        .foregroundColor(Color("primaryColor"))
                                                }
                                            }
                                        }
                                    }

                                }

                            }.padding(.horizontal)
                        }
                        //seの場合は下に余白
                        if UIScreen.main.bounds.size.height < 700{
                            Spacer()
                                .frame(height:10)
                        }
                    }
                    .padding(.vertical)
                }
                
                
                
                
                
            }
            .confirmationDialog("タイトル", isPresented: $showingActionSheet, titleVisibility: .hidden) {
                //すべてのレシピを含む献立作成導線
                Button("このレシピを含む献立を作成") {
                    //ログアウト時はログイン導線
                    //そうでなかったら、献立作成画面へ
                }
                //表示しているレシピを含む献立作成導線
                if recipeData.cookingRecipes.count > 1{
                    Button("\(recipeData.cookingRecipes.count)品全て含む献立を作成") {
                    }
                }
                Button("キャンセル", role: .cancel) {
                    // キャンセル処理
                    print("cancel")
                }
            }
            
            
            //URLが無効だったら表示されるバナー
            VStack{
                Spacer()
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.gray)
                        .frame(width:widthOfPhone-15,height:45)
                    HStack{
                        Text("無効なURLです")
                            .foregroundColor(.white)
                        Spacer()
                    }.padding(.horizontal,20)
                }
                .opacity(opacityOfNotFoundUrl)
                .animation(.default)
            }

        }
        .navigationTitle(recipeData.cookingRecipes.count > 0 ? recipeData.cookingRecipes[recipeNumber].name : "")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing:
                Button(action:{
                    showingActionSheet = true
                }){
                    VStack{
                        Image(systemName: "fork.knife")
                        Text("献立")
                            .font(.system(size: 10))
                            .bold()
                    }
                    .foregroundColor(Color("primaryColor"))
                }
        )
        .onAppear(){
            //GoogleAnalytics
//            Analytics.logEvent("Looked_Recipes", parameters: [
//                "userID": systemData.recipeData.userData.id != "" ? systemData.recipeData.userData.id : "ゲスト",
//                "maindish": (recipeData.cookingRecipes.first(where: ({$0.type == "主菜"})) ?? Recipe(id:"")).id,
//                "sidedish": (recipeData.cookingRecipes.first(where: ({$0.type == "副菜"})) ?? Recipe(id:"")).id,
//                "stapledish": (recipeData.cookingRecipes.first(where: ({$0.type == "主食"})) ?? Recipe(id:"")).id,
//                "soup": (recipeData.cookingRecipes.first(where: ({$0.type == "汁物"})) ?? Recipe(id:"")).id,
//                "date": dateFomrmatter.string(from: Date())
//            ])

            
            //人数を設定している人数にする
            numberOfPeople = recipeData.userData.numberOfPeople
            
            



            DispatchQueue.main.asyncAfter(deadline: .now() + Double(recipeData.cookingRecipes.count)*0.5) {
                appearing = true
            }
        }
        .onDisappear(){
            for i in 0..<recipeData.cookingRecipes.count{

                if recipeData.userData.lookedRecipesStr.contains(recipeData.cookingRecipes[i].id){
                    recipeData.userData.lookedRecipesStr.removeAll(where: {$0 == recipeData.cookingRecipes[i].id})
                }
                recipeData.userData.lookedRecipesStr.insert(recipeData.cookingRecipes[i].id, at: 0)
                if recipeData.userData.lookedRecipesStr.count == 51{
                    recipeData.userData.lookedRecipesStr.remove(at: recipeData.userData.lookedRecipesStr.count-1)
                }
            }
            UserDefaults.standard.set(recipeData.userData.lookedRecipesStr, forKey: "lookedRecipes")
        }
        .onChange(of: recipeNumber, perform: { value in
            imageAppearing = false
            DispatchQueue.main.asyncAfter(deadline: .now()+0.25){
                imageAppearing = true
            }
        })
    }
}

#Preview {
    CookingRecipeView()
}


//jsonデータ変換
extension Bundle {
    func decodeJSON<T: Codable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Faild to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        
        return loaded
    }
}
