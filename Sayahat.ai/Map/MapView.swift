//
//  MapView.swift
//  SayahatAIApp
//
//  Created by Beket Barlykov  on 02.07.2023.
//

import SwiftUI
import MapKit

struct MapView: View{
    @StateObject var locationsVM: LocationsViewModel = LocationsViewModel()
    @State private var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.238779, longitude: 76.948275),span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    @State var isOnUserLocation: Bool = true
    var body: some View {
        if locationsVM.locations == []{
            ProgressView()
        }else{
            ZStack{
                mapLayer
                    .ignoresSafeArea()
                
                VStack(spacing: 0){
                    
                    header
                        .padding()
                    Spacer()
                    
                    VStack(spacing: 0){
                        Spacer()
                        HStack{
                            Spacer()
                            userLocationButton
                                .padding()
                                .offset(y: 70)
                        }
                        locationsPreviewStack
                    }
                    
                }
            }
            .sheet(item: $locationsVM.sheetLocation, onDismiss: nil){
                location in
                LocationDetailView(locationsVM: locationsVM, location: location)
            }
            .onAppear{
                locationsVM.fetchLocations()
                LocationManager.shared.requestLocation()
            }
        }
    }
    
}


extension MapView{
    private var header: some View{
        VStack{
            
            Button{
                locationsVM.toggleShowLocationsList()
            }label: {
                Text(locationsVM.currMapLocation.name + ", " + locationsVM.currMapLocation.cityName).font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .animation(.none, value: locationsVM.currMapLocation)
                    .overlay(alignment: .leading){
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding()
                            .rotationEffect(Angle(degrees: locationsVM.showLocationsList ? 180 : 0))
                    }
            }
            if locationsVM.showLocationsList{
                LocationsListView(locationsVM: locationsVM)
            }
        }
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
    }
    
    private var mapLayer: some View{
        Map(coordinateRegion: $locationsVM.mapRegion, annotationItems: locationsVM.locations, annotationContent: {
            location in
            MapAnnotation(coordinate: location.coordinates){
                MapAnnotationView()
                    .scaleEffect(locationsVM.currMapLocation == location ? 1 : 0.7)
                    .shadow(radius: 10)
                    .onTapGesture {
                        // locationsVM.showNextLocation(nextLocation: location)
                        withAnimation(.easeInOut) {
                            locationsVM.currMapLocation = location
                            locationsVM.showLocationsList = false
                        }
                    }
            }
        })
    }
    
    private var locationsPreviewStack: some View{
        ZStack{
            ForEach(locationsVM.locations){ location in
                if locationsVM.currMapLocation == location
                {
                    LocationPreviewView(locationsVM: locationsVM, location: location)
                        .shadow(color: Color.black.opacity(0.3), radius: 20)
                        .padding()
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading))
                        )
                }
            }
        }
    }
    
    private var userLocationButton: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 32)
                .frame(width: 32, height: 32)
                .shadow(color: Color.black, radius: 4)
                .opacity(0.3)
                .foregroundColor(.gray)
            Image(systemName: isOnUserLocation ? "location.fill" : "location")
                .foregroundColor(.cyan)
                
        }
        .onTapGesture{
            if let location = locationsVM.locationManager.userLocation{
                let userLocation = Location(userLocation: location)
                locationsVM.showNextLocation(nextLocation: userLocation)
            }
            isOnUserLocation = true
        }
    }
}



struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView().environmentObject(LocationsViewModel())
    }
}
