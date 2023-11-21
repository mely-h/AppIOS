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
                    destination: SalonsView(),
                    isActive: $showNextView
                ) {
                    EmptyView()
                }
                .hidden()

                Button("Connecter") {
                        showNextView = true
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

struct Salon : Identifiable {
    var id = UUID()
    var nom : String
    var theme: String
    var nombredepersonne : Int
}

struct SalonsView: View {
    @State private var searchQuery = ""
    @State private var newSalonNom = ""
    @State private var newSalonTheme = ""
    @State private var newSalonNombreDePersonne = 0
 


    @State private var salons = [
        Salon(nom: "Salon1", theme: "Amour", nombredepersonne: 10),
        Salon(nom: "Salon2", theme: "Amitié", nombredepersonne: 15),
        Salon(nom: "Salon3", theme: "Etude", nombredepersonne: 20)
    ]

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
                        searchQuery.isEmpty || $0.nom.localizedCaseInsensitiveContains(searchQuery)
                    }) { salon in
                        NavigationLink(destination: ModifView(salon: $salons[getIndex(for: salon)], salons: $salons)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(salon.nom)
                                    Text("Thème: \(salon.theme)")
                                    Text("Nombre de personnes: \(salon.nombredepersonne)")
                                }
                                Spacer()
                                Button(action: {
                                    if let index = salons.firstIndex(where: { $0.id == salon.id }) {
                                        salons.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }

                                Button(action: {
                                
                                }) {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                .padding(.top, 8)

                VStack {
                    TextField("Nouveau Salon", text: $newSalonNom)
                        .padding(8)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)

                    TextField("Thème", text: $newSalonTheme)
                        .padding(8)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)

                    TextField("Nombre de personnes", value: $newSalonNombreDePersonne, formatter: NumberFormatter())
                        .padding(8)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)

                    Button(action: {
                        let newSalon = Salon(nom: newSalonNom, theme: newSalonTheme,
                                             nombredepersonne : newSalonNombreDePersonne)
                        salons.append(newSalon)
                        newSalonNom = ""
                        newSalonTheme = ""
                        newSalonNombreDePersonne = 0
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

    private func getIndex(for salon: Salon) -> Int {
        if let index = salons.firstIndex(where: { $0.id == salon.id }) {
            return index
        }
        return 0
    }
}

struct ModifView: View {
    @Binding var salon: Salon
    @Binding var salons: [Salon]

    var body: some View {
        VStack {
            TextField("Nom du Salon", text: $salon.nom)
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .padding(.top, 16)

            TextField("Thème", text: $salon.theme)
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .padding(.top, 8)

            TextField("Nombre de personnes", value: $salon.nombredepersonne, formatter: NumberFormatter())
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .padding(.top, 8)

            Button(action: {
                if let index = salons.firstIndex(where: { $0.id == salon.id }) {
                    salons[index] = salon
                }
            }) {
                
                
                Text("Enregistrer")
                    .padding(8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 16)
        }
        .padding(.horizontal, 16)
        .navigationTitle("Modifier Salon")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
