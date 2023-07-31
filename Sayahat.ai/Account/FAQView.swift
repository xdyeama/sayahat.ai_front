//
//  FAQView.swift
//  Sayahat.ai
//
//  Created by Beket Barlykov  on 29.07.2023.
//

import SwiftUI

struct FAQElement{
    var title: String
    var description: String
}

let faqList: [FAQElement] = [
    FAQElement(title: "What is Sayahat.ai App?", description: "Nowy is a one-stop AI-powered travel planner app around Kazakhstan that lets you uncover amazing travel plans around Kazakhstan. Sayahat.ai highlights the best destinations and enables users to plan, route, and book trips on one convenient platform."),
    FAQElement(title: "How is Sayahat.ai different from other platforms? Other travel or social apps?", description: "Sayahat from Kazakh language translates as journey, thus Sayahat.ai uses latest AI technologies trained on the big dataset of every place that tourists may find interesting in Kazakhsstan to help create best travel planning experience in Kazakhstan. "),
    FAQElement(title: "Is Sayahat.ai free?", description: "Sayahat.ai is a global app that is available for free to all users."),
    FAQElement(title: "How to request to delete your personal data", description: "To request to review, update, or delete your personal information, use request delete please contact us at info@nowy.io.")
]

struct FAQView: View {
    var body: some View {
        VStack{
            Section{
                Text("About Sayahat.ai App")
                List{
                    ForEach(faqList, id: \.title){ faqElement in
                        VStack{
                            Text(faqElement.title)
                                .font(.title3.bold())
                            Text(faqElement.description)
                                .font(.body)
                        }
                    }
                }
            }
        }
    }
}

struct FAQView_Previews: PreviewProvider {
    static var previews: some View {
        FAQView()
    }
}
