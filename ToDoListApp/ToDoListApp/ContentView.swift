import SwiftUI
import CoreData

struct SearchConfig: Equatable {
    var query: String = ""
}

struct ContentView: View {
    
    @State private var search: SearchConfig = .init()
    @State private var showingAlert = false
    @State private var toDoHolder: String = ""
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject private var taskFilter = TaskFilter()
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(taskFilter.filteredTasks, id: \.self) { todo in
                        HStack {
                            Text(todo.task ?? "")
                        }
                    }
                    .onDelete(perform: deleteTodo)
                }
                .listStyle(.automatic)
                .animation(.easeIn, value: taskFilter.filteredTasks.count)
                
                Spacer()
                
            }
            .searchable(text: $search.query)
            .onChange(of: search.query) { oldValue, newValue in
                taskFilter.updateFilter(query: newValue, context: viewContext)
            }
            .navigationTitle("To Do List")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showingAlert.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                    .alert("Add To Do", isPresented: $showingAlert) {
                        TextField("To Do", text: $toDoHolder)
                        Button("Submit") {
                            saveTodo()
                        }
                        
                        Button("Cancel", role: .cancel) {
                            toDoHolder = ""
                        }
                    } message: {
                        Text("Add item to your to do list")
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Text(Date().formatted(date: .complete, time: .omitted))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .onAppear {
            taskFilter.updateFilter(query: search.query, context: viewContext)
        }
    }
    
    private func saveTodo() {
        let todo = Task(context: self.viewContext)
        todo.id = UUID()
        todo.task = toDoHolder
        
        do {
            try viewContext.save()
            taskFilter.updateFilter(query: search.query, context: viewContext)
        } catch {
            print("Error saving context: \(error)")
        }
        
        toDoHolder = ""
    }
    
    private func deleteTodo(at offsets: IndexSet) {
        for index in offsets {
            let todo = taskFilter.filteredTasks[index]
            viewContext.delete(todo)
        }
        
        do {
            try viewContext.save()
            taskFilter.updateFilter(query: search.query, context: viewContext)
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

class TaskFilter: ObservableObject {
    @Published var filteredTasks: [Task] = []
    
    func updateFilter(query: String, context: NSManagedObjectContext) {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        if !query.isEmpty {
            request.predicate = NSPredicate(format: "task CONTAINS[cd] %@", query)
        }
        
        do {
            filteredTasks = try context.fetch(request)
        } catch {
            print("Error fetching tasks: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
