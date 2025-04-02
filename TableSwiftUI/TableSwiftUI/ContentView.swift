// ContentView.swift
// TableSwiftUI
//
// Created by Wilford, Makayla M on 3/31/25.
//

import SwiftUI
import MapKit

// Define an enum for the cuisines
enum Cuisine: String, CaseIterable {
    case mexican = "Mexican Food"
    case asian = "Asian Food"
    case southern = "Southern/Comfort Food"
    case all = "All"
}

let data = [
    Item(name: "Los Jambados Tacos", address: "302 Linda Dr, San Marcos, TX 78666", desc: "A local taco truck known for its authentic Mexican street tacos, flavorful meats, and casual atmosphere.", lat: 29.8725, long: -97.9406, imageName: "tacos", cuisine: .mexican),
    Item(name: "Garcia's", address: "403 S LBJ Dr, San Marcos, TX 78666", desc: "A well-loved Tex-Mex restaurant serving classic dishes like enchiladas, fajitas, and breakfast tacos in a cozy setting.", lat: 29.8776, long: -97.9409, imageName: "enchiladas", cuisine: .mexican),
    Item(name: "Gus's World Famous Fried Chicken", address: "110 E Martin Luther King Dr Suite 102, San Marcos, TX 78666", desc: "A popular chain specializing in crispy, spicy fried chicken with Southern-style sides like mac and cheese and baked beans.", lat: 29.8796, long: -97.9427, imageName: "chicken", cuisine: .southern),
    Item(name: "Toro Ramen and Poke Barn", address: "700 N LBJ Dr Suite 114, San Marcos, TX 78666", desc: "A modern eatery offering Japanese ramen bowls, poke bowls, and fusion dishes with fresh ingredients.", lat: 29.8890, long: -97.9418, imageName: "poke", cuisine: .asian),
    Item(name: "Xian Sushi and Noodle", address: "200 Springtown Way Suite 138, San Marcos, TX 78666", desc: "A restaurant featuring hand-pulled noodles, fresh sushi, and a mix of Chinese and Japanese-inspired dishes in a casual dining setting.", lat: 29.8924, long: -97.9225, imageName: "noodles", cuisine: .asian)
]

struct Item: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let desc: String
    let lat: Double
    let long: Double
    let imageName: String
    let cuisine: Cuisine
}

struct ContentView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 29.8822, longitude: -97.9377), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    @State private var selectedCuisine: Cuisine = .all // Default is 'All'

    // Filtered data based on selected cuisine
    var filteredData: [Item] {
        if selectedCuisine == .all {
            return data
        } else {
            return data.filter { $0.cuisine == selectedCuisine }
        }
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("San Marcos Restaurants")
                    .font(.title)
                    .bold()
                    .padding(.leading)
                
                // Cuisine filter Menu aligned to the left and set to black
                HStack {
                    Menu {
                        ForEach(Cuisine.allCases, id: \.self) { cuisine in
                            Button(action: {
                                selectedCuisine = cuisine
                            }) {
                                Text(cuisine.rawValue)
                            }
                        }
                    } label: {
                        Label("Cuisine", systemImage: "line.horizontal.3.decrease.circle.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    .padding(.leading)
                    .padding(.top, 10)
                }

                // List of filtered restaurants
                List(filteredData, id: \.name) { item in
                    NavigationLink(destination: DetailView(item: item)) {
                        HStack {
                            Image(item.imageName)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.address)
                                    .font(.subheadline)
                            }
                        }
                    }
                }

                Map(coordinateRegion: $region, annotationItems: filteredData) { item in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .font(.title)
                            .overlay(
                                Text(item.name)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                    .fixedSize(horizontal: true, vertical: false)
                                    .offset(y: 25)
                            )
                    }
                }
                .frame(height: 300)
                .padding(.bottom, -30)
            }
            .listStyle(PlainListStyle())
        }
    }
}

struct DetailView: View {
    @State private var region: MKCoordinateRegion
    
    init(item: Item) {
        self.item = item
        _region = State(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long), span: MKCoordinateSpan(latitudeDelta: 0.20, longitudeDelta: 0.20)))
    }
    
    let item: Item
    
    var body: some View {
        VStack {
            Image(item.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 300)
            
            Text("Address: \(item.address)")
                .font(.subheadline)
            
            Text("Description: \(item.desc)")
                .font(.subheadline)
                .padding(10)
        
            Spacer()
            
        
            Map(coordinateRegion: $region, annotationItems: [item]) { item in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .font(.title)
                        .overlay(
                            Text(item.name)
                                .font(.subheadline)
                                .foregroundColor(.black)
                                .fixedSize(horizontal: true, vertical: false)
                                .offset(y: 25)
                        )
                }
            }
            .frame(height: 300)
            .padding(.bottom, 0)
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}

#Preview {
    ContentView()
}
