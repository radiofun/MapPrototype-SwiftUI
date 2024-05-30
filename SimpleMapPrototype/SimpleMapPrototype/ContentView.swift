import SwiftUI
import MapKit

struct ContentView: View {

  let screenwidth = UIScreen.main.bounds.width
  let screenheight = UIScreen.main.bounds.height


  @State private var offset : CGFloat = 0 //offset value
  @State private var lastknownpos : CGFloat = 514 // default offset to not mess up with with translation
  @State private var mapOffset : CGFloat = -120 // default offset of Map
  @State private var mapHeight : CGFloat = UIScreen.main.bounds.height // default height of Map
  @State private var mapWidth : CGFloat = UIScreen.main.bounds.width // default width of Map


  var body: some View {
    ZStack{
      Color.gray.opacity(0.1) //Background Color
      Map() //This is Map, you can customize way more
        .mask(
          Rectangle()
            .frame(width:mapWidth,height:mapHeight)
            .cornerRadius(20)
        )
        .offset(y:mapOffset+offset)
      // Panel Layout
      VStack (alignment: .leading) {
        ForEach(0..<3) { row in
          Text("Map Prototype")
            .font(.headline)
            .padding(.leading,32)
            .padding(.top,24)
            .padding(.bottom,12)
          ScrollView(.horizontal, showsIndicators: false){
            HStack {
              ForEach(0..<5) { value in
                Rectangle()
                  .fill(.gray.opacity(0.3))
                  .frame(width: 144,height:110)
                  .cornerRadius(20)
              }
            }
          }
          .frame(width:UIScreen.main.bounds.width)
          .padding(.leading,24)
        }
        Spacer()
      }
      .frame(width:UIScreen.main.bounds.width,height:680)
      .background(.white)
      .cornerRadius(20)
      .offset(y:lastknownpos+offset)
      .gesture(
        DragGesture() // Drag Gesture Definition. Using MapRange
          .onChanged { value in
            offset = mapRange(value: value.translation.height, inMin: 0, inMax: -500, outMin: 0, outMax: -500)
            mapWidth = mapRange(value: value.translation.height, inMin: 40, inMax: -40, outMin: screenwidth, outMax: screenwidth-32)
            mapHeight = mapRange(value: value.translation.height, inMin: 200, inMax: -280, outMin: screenheight*0.8, outMax: 240)
          }
          .onEnded { value in // When Drag is over, based on position we trigger certain animation
            if value.translation.height < -100 {
              withAnimation(.spring()) {
                offset = 0
                mapOffset = -240
                mapHeight = 240
                mapWidth = screenwidth-32
                lastknownpos = 240
              }
            } else {
              withAnimation(.spring()) {
                offset = 0
                mapOffset = -120
                mapHeight = screenheight
                mapWidth = screenwidth
                lastknownpos = 514
              }
            }
          }
      )
    }
    .ignoresSafeArea()
  }
}

#Preview {
    ContentView()
}

//MapRange function
func mapRange(value:CGFloat, inMin:CGFloat, inMax:CGFloat, outMin:CGFloat, outMax:CGFloat) -> CGFloat {
  //default mapped value
  let mappedValue = ((value - inMin) * (outMax - outMin) / (inMax - inMin)) + outMin

  //you can also clamp the value so that it does not exceed value range
  let clampedValue = max(outMin, min(mappedValue, outMax))

  return mappedValue
}
