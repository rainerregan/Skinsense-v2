//
//  ContentView.swift
//  Skinsense
//
//  Created by Rainer Regan on 02/11/23.
//

import SwiftUI
import WrappingHStack

struct PersonalizationSheetItems {
    var title: String
    var subtitle: String
    var icon: String
}

struct PersonalizationView: View {
    var callback : (User?) -> Void
    var showButton: Bool = true
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var moc
    
    @StateObject var viewModel: PersonalizationViewModel = PersonalizationViewModel(isSheetOpened: true)
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ScrollView {
                // Title
                VStack(alignment: .leading) {
                    Text("Tell Us About Your Skin")
                        .font(.system(size: 33, weight: .bold))
                    Text("Share your skin type, concerns, and goals for personalized skincare recommendations!").fixedSize(horizontal: false, vertical: true)
                        .font(.subheadline)
                        .foregroundStyle(colorScheme == .light ? Color.customDarkGrey : Color.bgColor)
                }
                
                Spacer()
                    .frame(height: 25)
                
                VStack(spacing: 25) {
                    
                    // Skin Type
                    VStack(alignment: .leading) {
                        Text("Skin Type")
                            .font(.headline)
                        
                        // Bug fixed by Inez 7 Nov 2023 17:50:02
                        WrappingHStack(alignment:.leading) {
                            ForEach(viewModel.skinTypes, id: \.id) {
                                skinType in
                                
                                CustomCheckbox(onPress: { object in
                                    viewModel.addSkinType(skinType: object as! SkinType)
                                }, object: skinType, isActive: self.viewModel.selectedSkinTypes.contains(where: { test in
                                    test.id == skinType.id
                                }))
                            }
                        }
                        
                        Text("You may choose max two options")
                            .font(.subheadline)
                            .foregroundStyle(colorScheme == .light ? Color.customDarkGrey : Color.bgColor)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Skin Concerns
                    VStack(alignment: .leading) {
                        Text("Skin Concerns")
                            .font(.headline)
                        
                        // Bug fixed by Inez 7 Nov 2023 17:50:02
                        WrappingHStack(alignment:.leading) {
                            ForEach(viewModel.skinConcerns, id: \.id) {
                                skinConcern in
                                
                                CustomCheckbox(onPress: { object in
                                    viewModel.addSkinConcern(skinConcern: object as! SkinConcern)
                                }, object: skinConcern, isActive: self.viewModel.selectedSkinConcerns.contains(where: { test in
                                    test.id == skinConcern.id
                                }))
                                
                            }
                        }
                        
                        Text("You may choose max two options")
                            .font(.subheadline)
                            .foregroundStyle(colorScheme == .light ? Color.customDarkGrey : Color.bgColor)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Your allergen
                    VStack(alignment: .leading) {
                        Text("Your Allergen")
                            .font(.headline)
                        
                        // Bug fixed by Inez 7 Nov 2023 17:50:02
                        WrappingHStack(alignment:.leading) {
                            ForEach(viewModel.allergens, id: \.id) {
                                allergen in
                                
                                CustomCheckbox(onPress: { object in
                                    viewModel.addAllergen(allergen: object as! Allergen)
                                }, object: allergen, isActive: self.viewModel.selectedAllergens.contains(where: { test in
                                    test.id == allergen.id
                                }))
                            }
                        }
                        
                        Text("You may choose more than one")
                            .font(.subheadline)
                            .foregroundStyle(colorScheme == .light ? Color.customDarkGrey : Color.bgColor)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                Spacer()
                    .frame(height: 25)
            }
            
            if showButton {
                CustomButton(title: "Done", action: {
                    viewModel.handleUpdate(callback: self.callback)
                }, isDisabled:
                                viewModel.selectedSkinTypes.isEmpty || viewModel.selectedSkinConcerns.isEmpty || viewModel.selectedAllergens.isEmpty
                )
            }
        }
        .padding()
        .sheet(isPresented: $viewModel.isSheetOpened, content: {
            PersonalizationSheetView(isSheetOpened: $viewModel.isSheetOpened)
                .padding(.top, 32)
        })
    }
}

struct PersonalizationSheetView: View {
    @Binding var isSheetOpened : Bool
    
    var items: [PersonalizationSheetItems] = [
        PersonalizationSheetItems(
            title: "Allergen Detection",
            subtitle: "We'll help you identify potential allergens in your skincare products.",
            icon: "leaf.fill"
        ),
        PersonalizationSheetItems(
            title: "Skincare Ingredient Analysis",
            subtitle: "Our app analyzes ingredients, offering insights into what you're applying.",
            icon: "staroflife.fill"
        ),
        PersonalizationSheetItems(
            title: "Personalized Recommendation",
            subtitle: "Discover products that are perfectly suited to your unique skin type and preferences.",
            icon: "heart.fill"
        )
    ]
    
    var body: some View {
        VStack {
            // Block 1
            Text("Welcome to SkinSense")
                .font(.title)
                .multilineTextAlignment(.center)
                .bold()
            
            Spacer()
                .frame(height: 40)
            
            // Block 2
            VStack(spacing: 25) {
                ForEach(items, id: \.title) {
                    item in
                    HStack(spacing: 15) {
                        Image(systemName: item.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.mediumPurple)
                        
                        VStack(alignment:.leading) {
                            Text(item.title)
                                .font(.headline)
                            Text(item.subtitle)
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            
            Spacer()
            
            // Block 3
            VStack {
                Image("onboarding_icon_bottom")
                Spacer()
                    .frame(height: 16)
                Text("When you're exploring SkinSense services, you'll find a world of skincare knowledge at your fingertips. Our app analyzes ingredients, offering insights into what you're applying to your skin, and provides personalized product recommendations tailored to your unique needs. Discover a smarter way to care for your skin with SkinSense.")
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
                .frame(height: 30)
            
            // Button
            CustomButton(title: "Get Started", action: {
                isSheetOpened = false
            })
        }
        .padding()
    }
}

#Preview {
    PersonalizationView {_ in 
        // Unimplemented
    }
}
