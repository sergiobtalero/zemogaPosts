# zemogaPosts

## Architecture
The app has a Clean Architecture Approach, meaning that there's a separation of responsabilities by three different layers: Data, Domain and the app itself (ZemogaPosts).

Each layer has it's own responsabilities:

**Data:** 
In charged of managing the objects used by the app

Objects are retrieved via services and persisted locally through CoreData, for which access and control is managed by PersistenceManager, which exposes all necessary code to insert, delete or fetch NSManagedObjectModels out from the store.

There are also files to manage retrieval of data from the server, as well as a file called PostsProvider, which acts a source/store for current Posts allocated in memory.

**Domain:** 
Includes modules used by the app, to avoid direct manipulation of persisted information.

Has also definitions of interfaces of some major classes.

**ZemogaPosts:** 
App itself, written fully in SwiftUI whith a "sort-of approach" with MVVM, as the attempt to have a fullly written app in SwiftUI along Clean Architecture + MVVM, proved to be an interesting challenge, due to the nature of SwiftUI, which behaves better with single stores.

## Libraries used
Only one external framework was used: OHHTPStubs, used for stubbing responses on tests of Data layer.

## Testing
Data and app has tests, with a coverage enough to highlight different testing skills.

## How to run the project
Clone and wait for the packages to finish load. Make sure to have ZemogaPosts selected as scheme and a iOS simulator or device connected.
