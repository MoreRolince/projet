pipeline {
    agent any

    environment {
        CONTAINER_ID = ''
        SUM_PY_PATH = 'C:\\Users\\rolin\\OneDrive\\Bureau\\Projet\\sum.py'
        DIR_PATH = 'C:\\Users\\rolin\\OneDrive\\Bureau\\Projet'
        TEST_FILE_PATH = 'C:\\Users\\rolin\\OneDrive\\Bureau\\Projet\\test_variables.txt'
    }

    stages {

        stage('Build') {
            steps {
                script {
                    echo "🔨 Construction de l'image Docker..."
                    bat "docker build -t sum-image ${DIR_PATH}"
                }
            }
        }

        stage('Run') {
            steps {
                script {
                    echo "🚀 Démarrage du conteneur Docker..."
                    def output = bat(script: 'docker run -d sum-image', returnStdout: true)
                    def lines = output.split('\n')
                    CONTAINER_ID = lines[-1].trim()
                    echo "Conteneur ID: ${CONTAINER_ID}"
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    echo "🧪 Exécution des tests..."

                    // Lire les valeurs de test
                    def testLines = readFile(TEST_FILE_PATH).split('\n')

                    for (line in testLines) {
                        def vars = line.split(' ')
                        def arg1 = vars[0]
                        def arg2 = vars[1]
                        def expectedSum = vars[2].toFloat()

                        // Exécuter le script dans le conteneur
                        def output = bat(script: "docker exec ${CONTAINER_ID} python sum.py ${arg1} ${arg2}", returnStdout: true)
                        def result = output.split('\n')[-1].trim().toFloat()

                        if (result == expectedSum) {
                            echo "✅ Test réussi: ${arg1} + ${arg2} = ${result}"
                        } else {
                            error "❌ Échec du test: ${arg1} + ${arg2} attendu ${expectedSum}, mais obtenu ${result}"
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                echo "🧹 Nettoyage du conteneur..."
                bat "docker stop ${CONTAINER_ID}"
                bat "docker rm ${CONTAINER_ID}"
            }
        }
    }
}
