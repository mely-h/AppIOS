//
//  ContentView.swift
//  Hope
//
//  Created by mel on 20/11/2023.
//
 
import SwiftUI
import Firebase
import FirebaseAuth



struct ContentView: View {
    
    @State private var pseudo: String = ""
    @State private var nomAnimal: String = ""
    @State private var showNextView: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
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
                    
                    if isFormValid {
                        
                        Auth.auth().signInAnonymously { authResult, error in
                            
                            if let error = error {
                                
                                showAlert = true
                                
                            } else {
                                
                                showNextView = true
                                
                            }
                            
                        }
                        
                    } else {
                        
                        showAlert = true
                        
                        alertMessage = "Veuillez remplir tous les champs"
                        
                    }
                    
                }
                
                .padding()
                
                .background(Color.gray)
                
                .foregroundColor(.white)
                
                .cornerRadius(10)
                
            }
            
            .padding()
            
            .alert(isPresented: $showAlert) {
                
                Alert(title: Text("Erreur"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                
            }
            
        }
        
    }
    
}



class Salon: Identifiable, ObservableObject {
    
    var id = UUID()
    
    @Published var nom: String
    @Published var theme: String
    @Published var nombredepersonne: Int
    @Published var imageURL: String
    
    init(nom: String, theme: String, nombredepersonne: Int, imageURL: String) {
        
        self.nom = nom
        
        self.nombredepersonne = nombredepersonne
        
        self.theme = theme
        
        self.imageURL = imageURL
        
    }
    
}

class CollectionSalons: ObservableObject {
    @Published var salons: [Salon]
    
    init(salons: [Salon]) {
        self.salons = salons
    }
}


struct SalonsView: View {
    
    @State private var searchQuery = ""
    @State private var newSalonNom = ""
    @State private var newSalonTheme = ""
    @State private var newSalonNombreDePersonne = 0
    @State private var newSalonImageURL = ""
    @State var selectedSalonId: UUID? = nil
    @State private var proprieteView: Bool = false
    
  
    
    
    @StateObject private var collectionSalons = CollectionSalons(salons: [
        
        Salon(nom: "Salon1", theme: "Amour", nombredepersonne: 10, imageURL: "https://www.pinterest.fr/pin/49961877097842443/"),
        
        Salon(nom: "Salon2", theme: "Amitié", nombredepersonne: 15, imageURL: "https://www.pinterest.fr/pin/pingl-sur-copines--661395895268461907/"),
        
        Salon(nom: "Salon3", theme: "Etude", nombredepersonne: 20, imageURL: "https://www.pinterest.fr/pin/546694842261355264/")
        
    ])
    
    
    
    
    
    
    
    var body: some View {
        
        NavigationView {
            
            ScrollView{
                
                VStack {
                    
                    TextField("Recherche de Salons", text: $searchQuery)
                    
                        .padding(8)
                    
                        .background(Color(.systemGray5))
                    
                        .cornerRadius(8)
                    
                        .padding(.horizontal, 16)
                    
                        .padding(.top, 16)
                    
                    ForEach(collectionSalons.salons) { salon in
                        
                        VStack(spacing: 10) {
                            
                            AsyncImage(url: URL(string: "imageURL")) { image in
                                
                                image
                                
                                    .resizable()
                                
                                    .aspectRatio(contentMode: .fill)
                                
                            } placeholder: {
                                
                                Text("kjh")
                                
                            }
                            
                            .frame(width: 50, height: 50)
                            
                            .cornerRadius(8)
                            TextField("Image (URL)", text: $salon.imageURL)
                            
                            VStack(alignment: .leading) {
                                
                                Text(salon.nom)
                                
                                Text("Thème: \(salon.theme)")
                                
                                Text("Nombre de personnes: \(salon.nombredepersonne)")
                                
                            }
                            
                            HStack {
                                
                                Button(action: {
                                    
                                    if let index = collectionSalons.salons.firstIndex(where: { $0.id == salon.id }) {
                                        
                                        collectionSalons.salons.remove(at: index)
                                        
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
                            
                        }
                        
                        .padding(12)
                        
                    }
                    
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
                        
                        TextField("URL de l'image", text: $newSalonImageURL)
                        
                            .padding(8)
                        
                            .background(Color(.systemGray5))
                        
                            .cornerRadius(8)
                        
                        Button(action: {
                            
                            let newSalon = Salon(nom: newSalonNom,
                                                 
                                                 theme: newSalonTheme,
                                                 
                                                 nombredepersonne: newSalonNombreDePersonne,
                                                 
                                                 imageURL: newSalonImageURL)
                            
                            collectionSalons.salons.append(newSalon)
                            
                            newSalonNom = ""
                            
                            newSalonTheme = ""
                            
                            newSalonNombreDePersonne = 0
                            
                            newSalonImageURL = ""
                            
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
                        
                        if let selectedSalonID = selectedSalonId,
                           
                            let selectedSalon = collectionSalons.salons.first(where: {$0.id == selectedSalonID}) {
                            
                            ModifView(salonObservable: selectedSalon, salons: collectionSalons.salons)
                            
                        }
                        
                    } label: {
                        
                        EmptyView()
                        
                    }
                    
                }
                
                .navigationTitle("Salons")
                
            }
            
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
            
            TextField("URL de l'image", text: $salonObservable.imageURL)
            
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
