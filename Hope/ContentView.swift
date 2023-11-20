//
//  ContentView.swift
//  Hope
//
//  Created by mel on 20/11/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var pseudo: String = ""
    @State private var nomAnimal: String = ""
    @State private var showNextView: Bool = false
    
    var isFormValid: Bool {
          return !pseudo.isEmpty && !nomAnimal.isEmpty
      }

    var body: some View {
        NavigationView {
            VStack {
                Image("logo1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.white)

                TextField("Pseudo", text: $pseudo)
                    .padding(10)

                TextField("NomAnimal", text: $nomAnimal)
                    .padding(10)

                NavigationLink(
                    destination: Salons(),
                    isActive: $showNextView
                ) {
                    EmptyView()
                }
                .hidden()

                Button("Envoyer") {
                    if isFormValid {
                        showNextView = true
                    } else {
                        
                    }
                }
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
            
        }
    }
}

struct Salons: View {
    @State private var searchQuery = ""
    @State private var newSalonName = ""
    @State private var salons = ["Salon1", "Salon2", "Salon3"]

    var body: some View {
        NavigationView {
            VStack {
                TextField("Recherche de Salons", text: $searchQuery)
                    .padding(8)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)

                List {
                    ForEach(salons.filter {
                        searchQuery.isEmpty || $0.localizedCaseInsensitiveContains(searchQuery)
                    }, id: \.self) { salon in
                        VStack(alignment: .leading) {
                            Text(salon)
                        }
                    }
                }
                .padding(.top, 8)

                HStack {
                    TextField("Nouveau Salon", text: $newSalonName)
                        .padding(8)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)

                    Button(action: {
                        salons.append(newSalonName)
                        newSalonName = ""
                    }) {
                        Text("Ajouter")
                            .padding(8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .navigationTitle("Salons")
        }
    }
}

    
    
    
struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

