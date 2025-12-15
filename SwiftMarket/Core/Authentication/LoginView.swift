//
//  LoginView.swift
//  SwiftMarket
//
//  Created by Cihangir Kankaya on 10.12.2025.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                VStack(spacing: 12) {
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.6)
                    Text("SWIFT MARKET")
                        .font(.system(size: 23, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color("SecondColor"))
                }
                .padding(.bottom, 40)
                
                VStack(spacing: 20) {
                    
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                        
                        TextField("Username", text: $viewModel.username)
                            .textInputAutocapitalization(.never)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray5), lineWidth: 1)
                    )
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                        
                        SecureField("Password", text: $viewModel.password)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray5), lineWidth: 1)
                    )
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                    }
                    Button {
                        Task {
                            await viewModel.login()
                        }
                    } label: {
                        ZStack {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Log In")
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color("BrandColor"))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: Color("BrandColor").opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .disabled(viewModel.isLoading)
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text("Test Account:")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                    Text("emilys / emilyspass")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(Color("SecondColor"))
                }
                .padding(.bottom, 10)
            }
            .background(Color(.systemGray6))
        }
    }
}

#Preview {
    LoginView()
}
