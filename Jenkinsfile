pipeline {
    agent any

    environment {
        FLUTTER_HOME = '/home/jenkins/flutter'
        PATH = "$FLUTTER_HOME/bin:$PATH"
    }

    stages {
        stage('Copy Key Properties') {
            steps {
                // Copy the key.properties file
                sh 'cp /home/jenkins/key.properties refilc/android/key.properties'
            }
        }

        stage('Flutter Doctor') {
            steps {
                // Ensure Flutter is set up correctly
                sh 'flutter doctor'
            }
        }

        stage('Dependencies') {
            steps {
                // Get Flutter dependencies
                sh 'flutter pub get'
            }
        }

        stage('Build') {
            steps {
                // Build the Flutter project
                sh 'flutter build apk --release'
            }
        }

        stage('Archive') {
            steps {
                // Archive the APK
                archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/app-release.apk', fingerprint: true
            }
        }
    }

    post {
        always {
            // Clean up workspace after build
            cleanWs()
        }
    }
}
