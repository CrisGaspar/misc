import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Created by crisoti on 12/07/16.
 */
public class TrainRoutes {
    private static HashMap<String, HashSet<String>> stationToDestinationStations = new HashMap<>();
    private static final String routesFilename = "stations.csv";
    private static final String separator = ",";
    private static final String routesOutputSeparator = "->";

    public TrainRoutes() throws IOException {
        loadRoutesInformation();
    }

    protected void loadRoutesInformation() throws IOException {
        BufferedReader bufferedReader = new BufferedReader(new FileReader(routesFilename));
        String line;

        while ((line = bufferedReader.readLine()) != null) {
            String[] stations = line.split(separator);
            if ((stations == null) || (stations.length != 2)) {
                String errMsg = "Invalid file format: each line must be a comma-seperated pair of 2 station names";
                throw new IOException(errMsg);
            }
            // Use first station as the key in the station-to-destinations map
            String startStation = stations[0];
            String destination = stations[1];
            if (startStation.equals(destination)) {
                String errMsg = "Invalid file format: line has same station listed as both initial and final "
                                + "station: " + startStation;
                throw new IOException(errMsg);
            }

            // Symmetric addition: add pair in both given and reverse direction
            // NOTE: It's a reasonable assumption that a route can be used in both directions.
            addDestinationToHashMap(startStation, destination);
            addDestinationToHashMap(destination, startStation);
        }
    }

    protected void addDestinationToHashMap(String startStation, String destination) {
        // Create an initial set in case there were no previously known destinations
        HashSet<String> destinations = new HashSet<>();
        destinations.add(destination);

        // Try to add this set if key is not present (no previously known destinations)
        HashSet<String> existingDestinationStations = stationToDestinationStations.putIfAbsent(
                startStation,
                destinations);
        if (existingDestinationStations != null) {
            // at least 1 destination was already known, just add to existing set
            existingDestinationStations.add(destination);
        }
    }

    public boolean checkValidStations(String startStation, String destinationStation) {
        // Look both stations up in our station indexed map
        if (stationToDestinationStations.get(startStation) == null) {
            System.err.println("Start station " + startStation + " is invalid!");
            return false;
        }
        else if (stationToDestinationStations.get(destinationStation) == null) {
            System.err.println("End station " + destinationStation+ " is invalid!");
            return false;
        }

        return true;
    }

    // Returns list of possible routes between two train stations
    public ArrayList<LinkedList<String>> getRoutes (String startStation, String destinationStation,
                                                    HashSet<String> stationsSelected) {
        if (startStation.equals(destinationStation)) {
            return new ArrayList<>();
        }

        // Lookup destinations that we know of already starting with the startStation.
        HashSet<String> destinations = stationToDestinationStations.get(startStation);
        if (destinations == null) {
            return new ArrayList<>();
        }

        // 1 single route is stored as a linked list of strings
        // Each route is then stored in the array list
        ArrayList<LinkedList<String>> routes = new ArrayList<>();
        ArrayList<LinkedList<String>> routesToAdd = new ArrayList<>();
        
        // Add to the path from intial start station
        if (stationsSelected.contains(startStation)) {
            // we detected a cycle, so stop here
            return new ArrayList<>();
        }
        // station is not on the current path already
        stationsSelected.add(startStation);

        for(String currentDestination: destinations) {
            routesToAdd.clear();
            if (currentDestination.equals(destinationStation)) {
                LinkedList<String> route = new LinkedList<>();
                route.add(startStation);
                route.add(destinationStation);
                routesToAdd.add(route);
            }
            else {
                // Recursively find routes from currentDestination to destinationStation
                ArrayList<LinkedList<String>> subRoutes = getRoutes(currentDestination, destinationStation, 
                                                                    stationsSelected);
                for (LinkedList<String> subRoute: subRoutes) {
                    // For each route add the start station as the first one in the route
                    subRoute.addFirst(startStation);
                    routesToAdd.add(subRoute);
                }
            }

            routes.addAll(routesToAdd);
        }
        // We are done with routes involving current path so need to remov current start station 
        // from selected set
        stationsSelected.remove(startStation); 
        return routes;
    }

    public static void main(String[] args) {
        TrainRoutes trainRoutes;
        String startStation, destinationStation;
        try {
            System.out.print("enter start station>");

            // Read the start and end stations from console
            BufferedReader bufferRead = new BufferedReader(new InputStreamReader(System.in));
            startStation = bufferRead.readLine();

            System.out.print("enter end station>");
            destinationStation = bufferRead.readLine();

            trainRoutes = new TrainRoutes();
        }
        catch (IOException e) {
            e.printStackTrace(System.out);
            return;
        }

        HashSet<String> stationsSelected = new HashSet<>();
        if (!trainRoutes.checkValidStations(startStation, destinationStation)) {
            return;
        }
        ArrayList<LinkedList<String>> routes = trainRoutes.getRoutes(startStation, destinationStation, stationsSelected);

        if (routes.isEmpty()) {
            System.out.println("No routes found!");
        }
        else {
            System.out.println("Available routes are:");
            for (LinkedList<String> route: routes) {
                // Use streams to join the stations with the required separator
                String routeStr = route.stream().collect(Collectors.joining(routesOutputSeparator));
                System.out.println(routeStr);
            }
        }
    }
}
