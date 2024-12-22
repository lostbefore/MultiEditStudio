import SwiftUI

struct CreatorInfoView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text("制作者信息")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("孙少杰")
                Text("邮箱：lostbefore1129@gmail.com")
                Text("GitHub：https://github.com/lostbefore")
            }
            .font(.body)
            .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle("关于制作者")
    }
}

