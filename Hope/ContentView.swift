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

class Salon: Identifiable,  ObservableObject {
    var id = UUID()
    @Published var nom: String
    @Published var theme: String
    @Published var nombredepersonne: Int

    init(nom: String, theme: String, nombredepersonne: Int) {
        self.nom = nom
        self.nombredepersonne = nombredepersonne
        self.theme = theme
    }
    

   
}



struct SalonsView: View {
    @State private var searchQuery = ""
    @State private var newSalonNom = ""
    @State private var newSalonTheme = ""
    @State private var newSalonNombreDePersonne = 0
    @State var selectedSalonId: UUID? = nil
    @State private var proprieteView: Bool = false

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
                
                VStack {
                    ForEach(salons.filter {
                        searchQuery.isEmpty || $0.nom.localizedCaseInsensitiveContains(searchQuery)
                    }) { salon in
                        HStack(spacing : 10 ) {
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
                                selectedSalonId = salon.id
                                proprieteView = true
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(12)
                    }
                }
                .padding(.top, 16)
                
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
                                             nombredepersonne: newSalonNombreDePersonne)
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
                
                NavigationLink(isActive: $proprieteView) {
                    if let selectedSalonID  = selectedSalonId,
                       let selectedSalon = salons.first(where :{$0.id == selectedSalonID}){
                        ModifView(salonObservable: selectedSalon, salons: $salons)
                } else {}
            }
               label: {
                    EmptyView()
                }
            }
            .navigationTitle("Salons")
            
           
        }
    }
}


struct ModifView: View {
    @ObservedObject var salonObservable: Salon
    @Binding var salons: [Salon]

    var body: some View {
          VStack {
              TextField("Nom du Salon", text: $salonObservable.nom)
                  .padding(8)
                  .background(Color(.systemGray5))
                  .cornerRadius(8)
                  .padding(.top, 16)

              TextField("Thème", text: $salonObservable.theme)
                  .padding(8)
                  .background(Color(.systemGray5))
                  .cornerRadius(8)
                  .padding(.top, 8)

              TextField("Nombre de personnes", value: $salonObservable.nombredepersonne, formatter: NumberFormatter())
                  .padding(8)
                  .background(Color(.systemGray5))
                  .cornerRadius(8)
                  .padding(.top, 8)

              Button(action: {
                 
                  if let index = salons.firstIndex(where: { $0.id == salonObservable.id }) {
                      salons[index] = salonObservable
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
