import SwiftUI

struct MyEventsPage: View {
    let user: User
    @Binding var events: [Event]
    var onEditEvent: (Event) -> Void
    var onViewAttendees: (Event) -> Void
    
    var myEvents: [Event] {
        events.filter { $0.organizer == user.name }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                if myEvents.isEmpty {
                    VStack {
                        Spacer()
                        Image(systemName: "calendar.badge.plus").font(.system(size: 60)).foregroundColor(.secondary)
                        Text("No Events Yet").font(.title2).bold()
                        Text("Tap the 'Post' tab to create your first event.").font(.subheadline).foregroundColor(.secondary).multilineTextAlignment(.center)
                        Spacer()
                    }.padding().frame(minHeight: 500)
                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(myEvents) { event in
                            MyEventManagementCard(event: event, onEdit: {
                                onEditEvent(event)
                            }, onViewAttendees: {
                                onViewAttendees(event)
                            }, onDelete: {
                                events.removeAll { $0.id == event.id }
                            })
                        }
                    }.padding()
                }
            }
            .navigationTitle("My Events")
        }
    }
}
