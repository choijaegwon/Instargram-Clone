# Instargram-Clone

Github: https://github.com/choijaegwon/Instargram-Clone  
Skills: ActiveLabel, CocoaPods, Firebase, MVC  
생성일: 2022/09/30

## 개요.

- Firebase사용법과 Delegate패턴, MVC패턴,  코드로 UI구현을 학습하기 위한 기능학습 프로젝트 입니다.

## 구현기능.

- 게시글 올리기
- 댓글
- 맨션
- 좋아요
- 해시태그
- 알람 받기
- DM메시지 보내기
- 프로필 편집하기

## 배운점.

### 스토리보드를 사용하지 않고 코드로 UI 구현

- 코드로 UI를 구현하니 View의 재사용성이 높아지고, 
스토리보드에 없는 옵션들을 따로 적지 않고 하나로 묶어줄 수 있어서 더욱 좋았던 것 같습니다.
또 extension을 사용해서, 쉽게 anchor잡고 활용하는 방법을 배웠습니다.

### Delegate패턴

- 막상 많이 사용한다는 말만 들었었는데 직접 구현해서 사용해 보니 
언제 사용하고, 왜 사용하는지 이해하였습니다.

### MVC디자인 패턴

- MVC패턴을 먼저 파악을 하고 왜 MVC패턴이 큰 프로젝트에선 안쓰이는지 파악하기위해,
MVVM패턴보다 오래된 MVC패턴을 활용한 강의를 들었습니다. 
제가 직접 MVC패턴 느껴본 바로는, 대부분의 코드가 Controller에 있으며,  뷰와 모델의 완벽한 분리가 어렵고 앱이 커지면 컨트롤러의 코드량이 커져 유지보수 하기 힘들것 같습니다.

### Firebase활용

- FirebaseAuth를 활용한 로그인
    
![Untitled](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/7baddad1-eb13-43f6-ba85-f3f4657e2a5f)  
    
- Realtime Database를 활용한 실시간 데이터 통신
    
![Untitled 1](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/f45b3bc4-4dd1-4a80-8e27-d61853a7bf63)  
    
- Storage를 활용한 사진 데이터 저장
    
![Untitled 2](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/0f826408-009c-4559-85b2-ac73f6408c7c)  
    
- messaging를 활용한 전체메시지
    
![Untitled 3](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/bf511501-249d-48e4-a694-a23c4385662f)   
    

## 오류 해결방안

### cell안에 이미지와 버튼을 추가하고, Tap Gesture와 Add Target을 실행해보려했는데 실행이 되지않는 오류가 발생.

- 해결방법1: UITableViewCell에서는 cell 맨 상위에는 content View가 존재한다는걸 확인하였고, 아래 코드를 작성해 주었더니 실행이 되었다.

```swift
cell.contentView.isUserInteractionEnabled = false
```

- 해결방법2: addSubview를 할떄, contentView에 추가하기.

```swift
addSubview(stack)
// 대신에,
contentView.addSubview(stack)
```

- 배운점: TableView가 cell 크기를 계산할 때에는 contentView에 추가된 subview들을 기준으로 한다는걸 배웠습니다.

### 시연연상

![Oct-16-2022_23-28-09](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/8fb64354-ec46-460d-9b80-6eb23813f453)  

![Oct-16-2022_23-31-55](https://github.com/choijaegwon/choijaegwon.github.io/assets/68246962/98abaac3-41d5-444d-bda2-3b4c82579b52)  
