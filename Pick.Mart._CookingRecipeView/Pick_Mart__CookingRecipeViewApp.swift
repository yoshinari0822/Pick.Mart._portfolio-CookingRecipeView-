//
//  Pick_Mart__CookingRecipeViewApp.swift
//  Pick.Mart._CookingRecipeView
//
//  Created by 金山義成 on 2024/01/13.
//

import SwiftUI

@main
struct Pick_Mart__CookingRecipeViewApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(RecipeData())
        }
    }
}
