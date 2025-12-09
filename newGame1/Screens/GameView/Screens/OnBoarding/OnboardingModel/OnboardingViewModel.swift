//
//  OnboardingViewModel.swift
//  Baraban
//
//  Created by никита уваров on 30.08.24.
//

import UIKit

enum Onboardingtype {
    case main
    
    case chapter1
    case chapter2
    case chapter3
    case chapter4
    
    case chapterFinished1
    case chapterFinished2
    case chapterFinished3
    case chapterFinished4
}

struct OnboardingModel {
    let image: UIImage?
    let text: String
}

class OnboardingViewModel {
    var mainOnbordingData: [OnboardingModel] = [
        OnboardingModel(image: UIImage(named: "OnboardingMain1"), text: "OnboardingCell.Main.Text1".localized()),
        OnboardingModel(image: UIImage(named: "OnboardingMain2"), text: "OnboardingCell.Main.Text2".localized()),
        OnboardingModel(image: UIImage(named: "OnboardingMain3"), text: "OnboardingCell.Main.Text3".localized()),
        OnboardingModel(image: UIImage(named: "OnboardingMain4"), text: "OnboardingCell.Main.Text4".localized()),
        OnboardingModel(image: UIImage(named: "OnboardingMain5"), text: "OnboardingCell.Main.Text5".localized()),
        OnboardingModel(image: UIImage(named: "OnboardingMain6"), text: "OnboardingCell.Main.Text6".localized()),
        OnboardingModel(image: UIImage(named: "OnboardingMain7"), text: "OnboardingCell.Main.Text7".localized())
    ]
    
    var chapter1OnbordingData: [OnboardingModel] = [
        OnboardingModel(image: UIImage(named: "OnboardingChapter1"), text: "OnboardingCell.Chapter1.Text1".localized()),
        OnboardingModel(image: UIImage(named: "OnboardingChapter12"), text: "OnboardingCell.Chapter1.Text2".localized())
    ]
    
    var chapter2OnbordingData: [OnboardingModel] = [
        OnboardingModel(image: UIImage(named: "OnboardingChapter2"), text: "OnboardingCell.Chapter2.Text1".localized()),
        OnboardingModel(image: UIImage(named: "OnboardingChapter22"), text: "OnboardingCell.Chapter2.Text2".localized())
    ]
    
    var chapter3OnbordingData: [OnboardingModel] = [
        OnboardingModel(image: UIImage(named: "OnboardingChapter3"), text: "OnboardingCell.Chapter3.Text1".localized()),
        OnboardingModel(image: UIImage(named: "OnboardingChapter32"), text: "OnboardingCell.Chapter3.Text2".localized()),
        OnboardingModel(image: UIImage(named: "OnboardingChapter33"), text: "OnboardingCell.Chapter3.Text3".localized()),
        OnboardingModel(image: UIImage(named: "OnboardingChapter34"), text: "OnboardingCell.Chapter3.Text4".localized())
    ]
    
    var chapter4OnbordingData: [OnboardingModel] = [
        OnboardingModel(image: UIImage(named: "OnboardingChapter4"), text: "OnboardingCell.Chapter4.Text1".localized()),
        OnboardingModel(image: UIImage(named: "OnboardingChapter42"), text: "OnboardingCell.Chapter4.Text2".localized()),
        OnboardingModel(image: UIImage(named: "OnboardingChapter43"), text: "OnboardingCell.Chapter4.Text3".localized())
    ]
    
    var chapterFinished1OnbordingData: [OnboardingModel] = [
        OnboardingModel(image: UIImage(named: "OnboardingChapterf1"), text: "OnboardingCell.Chapter1.Finished.Text1".localized())
    ]
    
    var chapterFinished2OnbordingData: [OnboardingModel] = [
        OnboardingModel(image: UIImage(named: "OnboardingChapterf2"), text: "OnboardingCell.Chapter2.Finished.Text1".localized()),
        OnboardingModel(image: UIImage(named: "OnboardingChapterf22"), text: "OnboardingCell.Chapter2.Finished.Text2".localized()),
        OnboardingModel(image: UIImage(named: "OnboardingChapterf23"), text: "OnboardingCell.Chapter2.Finished.Text3".localized())
    ]
    
    var chapterFinished3OnbordingData: [OnboardingModel] = [
        OnboardingModel(image: UIImage(named: "OnboardingChapterf3"), text: "OnboardingCell.Chapter3.Finished.Text1".localized()),
        OnboardingModel(image: UIImage(named: "OnboardingChapterf32"), text: "OnboardingCell.Chapter3.Finished.Text2".localized()),
        OnboardingModel(image: UIImage(named: "OnboardingChapterf33"), text: "OnboardingCell.Chapter3.Finished.Text3".localized())
    ]
    
    var chapterFinished4OnbordingData: [OnboardingModel] = [
        OnboardingModel(image: UIImage(named: "OnboardingChapterf4"), text: "OnboardingCell.Chapter4.Finished.Text1".localized()),
        OnboardingModel(image: UIImage(named: "OnboardingChapterf42"), text: "OnboardingCell.Chapter4.Finished.Text2".localized()),
        OnboardingModel(image: UIImage(named: "OnboardingChapterf43"), text: "OnboardingCell.Chapter4.Finished.Text3".localized()),
        OnboardingModel(image: UIImage(named: "OnboardingChapterf44"), text: "OnboardingCell.Chapter4.Finished.Text4".localized()),
        OnboardingModel(image: UIImage(named: "OnboardingChapterf45"), text: "OnboardingCell.Chapter4.Finished.Text5".localized())
    ]
}
