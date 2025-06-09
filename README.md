# Flutter Web App

## Overview
This Flutter web app showcases a dynamic news and trends feed using data. It is designed to be deployed on GitHub Pages and provides a realistic user experience with clickable links to real, existing websites.

## Features
- **Dynamic News Feed**: Displays a shuffled list of dummy news articles with realistic titles, descriptions, and images.
- **Tech Trends Section**: Shows a list of tech trends with dynamic data and clickable links.
- **Responsive Design**: Optimized for both desktop and mobile viewing.
- **Realistic URLs**: All links point to real, existing websites, ensuring a seamless user experience.
- **Company Trends**: Track the latest trends and developments in the tech industry.
- **Funding Tracker**: Monitor funding rounds and investment activities of startups and companies.
- **User Profiles**: Create and manage user profiles to personalize the experience and track favorite trends and news.

## Setup
1. **Clone the Repository:**
   ```bash
   git clone https://github.com/yourusername/your-repo-name.git
   cd your-repo-name
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the App Locally:**
   ```bash
   flutter run -d chrome
   ```

## Deployment
1. **Build the Flutter Web App:**
   ```bash
   flutter build web
   ```

2. **Push the Built Files to GitHub:**
   ```bash
   git add .
   git commit -m "Update README.md and remove build folder from Git tracking"
   git push -u origin main
   ```

3. **Deploy to GitHub Pages:**
   - Go to your GitHub repository.
   - Navigate to **Settings** → **Pages**.
   - Under **Source**, select the branch (usually `main` or `master`) and the folder (`/docs` or `/`).
   - Click **Save**.

## Technologies Used
- **Flutter**: For building the web app.
- **GitHub Pages**: For hosting the static files.

## Contributing
Feel free to open issues or submit pull requests if you have suggestions for improvements.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
