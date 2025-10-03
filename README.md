# VideoFeed
<img width="1024" height="1024" alt="Gemini_Generated_Image_rsmue1rsmue1rsmu" src="https://github.com/user-attachments/assets/1cbe4813-a0b7-4b7d-b175-4fb23731d25e" />
<br>
<img width="1206" height="2622" alt="Simulator Screenshot - Clone 1 of iPhone 16 Pro - 2025-10-03 at 06 31 50" src="https://github.com/user-attachments/assets/8022d8ee-60a2-443f-b1d1-53e1368224a6" />
<img width="1206" height="2622" alt="Simulator Screenshot - Clone 1 of iPhone 16 Pro - 2025-10-03 at 06 31 55" src="https://github.com/user-attachments/assets/ae49c649-2b7b-485b-9564-d7b0ca3a7cbd" />
<img width="1206" height="2622" alt="Simulator Screenshot - Clone 1 of iPhone 16 Pro - 2025-10-03 at 06 31 52" src="https://github.com/user-attachments/assets/1df86689-622a-4ce2-8698-3973be5f478e" />

<h1>Project Architecture</h1>
<p>Project is designed on MVVM Architecture for 4 goals</p>
<ul>
  <li>Testability</li>
  <li>Maintainability</li>
  <li>Scalability</li>
  <li>Modularity</li>
  <li>CI/CD with Github Actions</li>
</ul>

<h1>Architecture General</h1>
<img width="1031" height="672" alt="Screenshot 2025-10-03 at 10 15 04 AM" src="https://github.com/user-attachments/assets/ace79597-4bc4-4adb-ab7a-cce04c90b59c" />

<ul>
  <li>Views</li>
  <li>ViewModels</li>
  <li>Models</li>
  <li>Services</li>
</ul>

<h2>Views</h2>
<ul>
  <li>Have main responsible on displaying videos</li>
  <li>Receive user actions include scrolling, sending messages, etc... and tell ViewModels do it</li>
</ul>

<h2>View Models</h2>
<ul>
  <li>Main business logic layer such as handling View's states as well as managing videos and all business logics on the videos to make sure the memory, network usages are optimized the best.</li>
  <li>Receive request data/action from Views, then tell Services Layer to collect the data, particularly here is the video URLs</li>
  <li>Once receive the video urls from the Service Layers, ViewModels convert urls to the VideoFeed objects. More than that, ViewModels then manage and process the videos to provide what UI needs with the best performance and optimization.</li>
</ul>

<h2>Services</h2>
<ul>
  <li>Has main responsible on fetching data to provide to the ViewModels</li>
<li>Service Layer is built from the Protocols to help us easily switch/change without impacting to the current business.</li>
<li>Service layer in this application has only one function to load the video URLs</li>
<li>In the next version of the application, once we support offline data, Service has responsible to connect to the Storage Service to store/get data from the storage if offline</li>
<li>In this version, we don't have the storage service yet</li>
</ul>


<h1>Overall Approach and Key Trade-Offs</h1>
- The most challenge of this application is not from how we load the video urls, neither how we load the HLS Video files on the UI. It has 3 most challenges:
<p>+ How we can display the videos very well, fast and specially no Black Flash when we scroll between the videos</p>
<p>+ How we ensure the memory is not increasing continously</p>
<p>+ How we ensure the network usage is optimized on loading the HLS videos</p>
<p>+ And, definitely we have the Trade-Offs, as long as they are acceptable.</p>

<h2>So, what's the approach?</h2>
<p>- In terms of Video processing, loading in the AV Foundation, there are 2 concepts. AVPlayer and AVQueuePlayer. Basically, AVPlayer is a representative for one video player. AVQueuePlayer is a representative for a list of video player.</p>
<p>- It would be easy to just use one AVPlayer and display the video we want wouldn't it? No, it's not simple like that. We would be Black Flash on scrolling.</p>
<p>- Or, to avoid the Black Flashing on scrolling, Apple designed the AVQueuePlayer that the video can be transitioned to another one with no flashing. Sounds good? Unfortunately, it helps the flash but it doesn't help the memory optimization. AVQueuePlayer is just designed for the Forward scrolling, not Backward. That means you can optimize the memory on the way straight, but on the way back, you will have a big problem.</p>
<p>- So, to solve all of this problems, we have to manage the individual AVPlayer for each Video. BUT, we won't load and keep AVPlayer for all videos. The memory could be out of bound and that's worst.</p>
<p>- Instead of that, we will use the Window strategy to manage the previous-current-next videos. The videos inside the window, we will keep their AVPlayers. The ones outside the window will be paused and destroyed.</p>
<p>- That way allows us to control the memory usuage for the app.</p>
<p>- So, what is the window size? What's the best one? Well, actually there are no best option for the window size here. This is a trade off. To decide what's the window size, we can consider the device model. Strongest and newest model could have a bigger window size because of the memory is big. But, for the lower device model, the window size can't be too big because the memory is limited. If we increase the window size, the video could be displayed fast and well, but it will take more memory. </p>
<p>- By default, currently, I am setting the window size is 5, but for the next version, we can definitely check the device model to give the window size accordingly.</p>
<p>- Network usage is the same, window size big could help to save bandwidth on loading video if we go back and forth many times. But it will take more memory.</p>

<h1>Let's talk about Messaging</h1>
In the concept of this application, we will have to handle the messaging UI and its state. Here's we have 3 states:
<p>- Default: This is the state when we are displaying the video or scrolling the video</p>
<p>- Focus: This is when we focus to the message text field</p>
<p>- Typing: This is when we are typing the message content</p>

In the app, ViewModel has responsible on managing this messageing UI States.
VideoFeedHomeViewModel
   <p>- $comment: This is a @Published variable that the View is listening it to know whether the comment/message has typed.</p>
   <p>- $isTyping: This is a @Published variable that the View is listening it to know whether we're typing or not.</p>
Here's the flow:

<p>User -> launch application -> tap to the textfield -> ViewModel update isTyping = true -> View hide Like and Send button -> View pause the video, disable scrolling, and show an overlay black color</p>
<p>User -> type the message -> ViewModel update $comment -> View show the Send button but hide Like button</p>
<p>User -> tap to overlay black background to cancel typing the message -> ViewModel update isTyping = false -> View show the Send and Like button back</p>
<p>User -> tap to send button -> ViewModel reset $comment, $isTyping -> View remove the Overlay Black Background, start playing video and scrolling.</p>

<h1>How to build automation test?</h1>
The application is designed for the testability, so here's the steps:
1. Test API Logic
- Create MockVideoFeedService implement VideoFeedServiceProtocol

2. Test Business Logic
<p>Create MockVideoFeedUseCase implement VideoFeedUseCaseProtocol</p>
<p>Create MockVideoFeedViewModel implement VideoFeedHomeViewModelProtocol</p>
<p>Now you can easily write the automation integration tests for API, Businesses</p>

<img width="1241" height="415" alt="Screenshot 2025-10-03 at 6 38 09 AM" src="https://github.com/user-attachments/assets/6f32d9f9-93ab-4e6c-b3b4-ca9bf9200f49" />
<img width="1326" height="673" alt="Screenshot 2025-10-03 at 6 37 23 AM" src="https://github.com/user-attachments/assets/88afb7c6-987f-4a76-9686-3ea25700b012" />

<code>
This is one automation test that I built.
func test_invalidURL() async {
        
        let service = MockVideoFeedService()
        service.isInvalidURL = true
        
        do {
            let res = try await service.loadVideoFeeds()
            XCTAssertTrue(res.count == 0)
        } catch {
            XCTAssertTrue(error.localizedDescription == APIError.InvalidURL.localizedDescription)
        }
        
    }
</code>

<h1>Installation</h1>
<ul>
  <li>Install Xcode 16.2 or later</li>
  <li>Go to VideoFeed folder where the xcodeproj is</li>
  <li>Open xcodeproj file and compile</li>
</ul>
