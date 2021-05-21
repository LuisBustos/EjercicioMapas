//
//  ViewController.swift
//  EjercicioMapas
//
//  Created by Luis Enrique Bustos Ramirez on 15/05/21.
//

import UIKit
import CoreLocation
import MapKit
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var admUbication = CLLocationManager()
    var mapa : MKMapView!
    var dataStorage : [[String:Double]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let laUrl = "http://janzelaznog.com/DDAM/iOS/BatmanLocations.json"
        admUbication.desiredAccuracy = kCLLocationAccuracyHundredMeters
        admUbication.delegate = self
        
        AF.request(laUrl, method:.get).validate().responseJSON { response in
                //print(response.value! )
                if let arreglo = response.value as? [[String:Double]]{
                    print("Algo 2 ")
                    self.dataStorage = arreglo
                    
                }else {
                    print("Algo")
                }
                
            }

        mapa = MKMapView()
        mapa.frame = self.view.bounds
        mapa.mapType = .hybrid
        mapa.delegate = self
        self.view.addSubview(mapa)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
        
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var i = 1
        
        var coordenadas : Array<CLLocationCoordinate2D> = []
        for objetos in dataStorage{
            print( "Coordenada \(i)", objetos)
            let coord1 = objetos["latitud"] ?? 0
            let coord2 = objetos["longitud"] ?? 0
            let coordenada = CLLocationCoordinate2D(latitude: coord1, longitude: coord2)
            self.creaPin(coordenada,  "Batman \(i)")
            i = i+1
            coordenadas.append(coordenada)
        }
        
        
        if let region = MKCoordinateRegion(coordinates: [coordenadas[0], coordenadas[4]]) {
            self.mapa.setRegion(region, animated: true)
        }
        // Iniciamos una solicitud de direcciones al servicio de mapas
        var request = MKDirections.Request()
        // configuramos el punto de inicio de la ruta
        request.source = MKMapItem(placemark: MKPlacemark(coordinate:coordenadas[0]))
        // configuramos el destino de la ruta
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate:coordenadas[4]))
        // especificamos el tipo de transporte
        request.transportType = .automobile
        // Si queremos todas las rutas posibles, en transportType indicamos ".any" y configuramos esta propiedad:
        request.requestsAlternateRoutes = true
        // preparamos el request para ejecutarse
        var indicaciones = MKDirections(request: request)
        // configuramos el closure para procesar la respuesta
        indicaciones.calculate { response, error in
            if error != nil {
                print ("no hubo respuesta del servicio de Directions")
                return
            }
            if let ruta = response?.routes.first {
                self.mapa.addOverlay(ruta.polyline)
            }
        }
        
        request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate:coordenadas[4]))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate:coordenadas[3]))
        request.requestsAlternateRoutes = true
        // preparamos el request para ejecutarse
        indicaciones = MKDirections(request: request)
        // configuramos el closure para procesar la respuesta
        indicaciones.calculate { response, error in
            if error != nil {
                print ("no hubo respuesta del servicio de Directions")
                return
            }
            if let ruta = response?.routes.first {
                self.mapa.addOverlay(ruta.polyline)
            }
        }
        
        request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate:coordenadas[3]))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate:coordenadas[2]))
        request.requestsAlternateRoutes = true
        // preparamos el request para ejecutarse
        indicaciones = MKDirections(request: request)
        // configuramos el closure para procesar la respuesta
        indicaciones.calculate { response, error in
            if error != nil {
                print ("no hubo respuesta del servicio de Directions")
                return
            }
            if let ruta = response?.routes.first {
                self.mapa.addOverlay(ruta.polyline)
            }
        }
        
        request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate:coordenadas[2]))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate:coordenadas[1]))
        request.requestsAlternateRoutes = true
        // preparamos el request para ejecutarse
        indicaciones = MKDirections(request: request)
        // configuramos el closure para procesar la respuesta
        indicaciones.calculate { response, error in
            if error != nil {
                print ("no hubo respuesta del servicio de Directions")
                return
            }
            if let ruta = response?.routes.first {
                self.mapa.addOverlay(ruta.polyline)
            }
        }
        
        request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate:coordenadas[1]))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate:coordenadas[0]))
        request.requestsAlternateRoutes = true
        // preparamos el request para ejecutarse
        indicaciones = MKDirections(request: request)
        // configuramos el closure para procesar la respuesta
        indicaciones.calculate { response, error in
            if error != nil {
                print ("no hubo respuesta del servicio de Directions")
                return
            }
            if let ruta = response?.routes.first {
                self.mapa.addOverlay(ruta.polyline)
            }
        }
        
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                admUbication.delegate = self
                admUbication.requestAlwaysAuthorization()
                break

            case .restricted, .denied:
                let alert = UIAlertController(title: "Error", message: "Se requiere su permiso para usar la ubicación, Autoriza ahora?", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "SI", style: UIAlertAction.Style.default, handler: { action in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, options: [:],completionHandler:nil)
                    }
                }))
                alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

                break

            default:    // .authorizedWhenInUse, .authorizedAlways
                admUbication.startUpdatingLocation()
                break
            }
        }
    }
    
    func creaPin(_ coordenada : CLLocationCoordinate2D,_ tag : String){
        // Ubicar el mapa, necesitamos el centro, y la distancia para poder crear una region
        let region = MKCoordinateRegion(center: coordenada, latitudinalMeters:100, longitudinalMeters:100)
        // aplicar la region al mapa, para lograr que se desplace y haga zoom
        mapa.setRegion(region, animated: true)
        let elPin = MKPointAnnotation()
        elPin.coordinate = coordenada
        elPin.title = tag
        mapa.addAnnotation(elPin)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        admUbication.stopUpdatingLocation()
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations : [CLLocation]){
        admUbication.stopUpdatingLocation()
        guard let ubicacion = locations.first else {return}
        CLGeocoder().reverseGeocodeLocation(ubicacion, completionHandler: { lugares, error in
            var direccion = ""
            if error != nil {
                print ("no se pudo encontrar la dirección correspondiente a esa coordenada")
                return
            }
            else {
                guard let lugar = lugares?.first else { return }
                let thoroughfare = (lugar.thoroughfare ?? "")
                let subThoroughfare = (lugar.subThoroughfare ?? "")
                let locality = (lugar.locality ?? "")
                let subLocality = (lugar.subLocality ?? "")
                let administrativeArea = (lugar.administrativeArea ?? "")
                let subAdministrativeArea = (lugar.subAdministrativeArea ?? "")
                let postalCode = (lugar.postalCode ?? "")
                let country = (lugar.country ?? "")
                direccion = "Dirección: \(thoroughfare) \(subThoroughfare) \(locality) \(subLocality) \(administrativeArea) \(subAdministrativeArea) \(postalCode) \(country)"
                print (direccion)
            }
           self.creaPin(ubicacion.coordinate, direccion)

        })
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            // si los permisos están bien ,comenzamos a recibir lecturas GPS
            admUbication.startUpdatingLocation()
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        render.strokeColor = UIColor.blue
        render.lineWidth = 3
        return render
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print ("cambio la region!")
        let regionActual = mapView.region
        print (regionActual)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // en este metodo podemos personalizar la vista que se utilizara para cada anotacion (pin) que se coloca en el mapa
        let identificador = "unPin"
        // las vistas de anotaciones sobre el mapa son reutilizables
        var anotacion = mapa.dequeueReusableAnnotationView(withIdentifier: identificador)
        if anotacion == nil {
            // si no existía una vista que se pueda reusar, se crea una
            // MKAnnotationView si se quiere personalizar la anotacion con una imagen
            // MKPinAnnotationView solo permite poner pines
            anotacion = MKAnnotationView(annotation: annotation, reuseIdentifier: identificador)
            // esta propiedad permite que el pin muestre información cuando el usuario lo toca
            anotacion?.canShowCallout = true
        }
        else {
            // si ya existia una vista, simplemente se le cambia la anotacion (pin)
            anotacion?.annotation = annotation
        }
        anotacion?.image = UIImage(named: "Batman")
        return anotacion
    }

}

