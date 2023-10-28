#define STB_IMAGE_IMPLEMENTATION
#include <RocketEngine.hpp>
#include <time.h>
#include <wait.h>

#include "ECS/Roc_ECS_Additions.hpp"

//#include "cereal/details/helpers.hpp"
#include <fstream>
#include <cmath>

class RocApplication : public Application
{
public:
    RocApplication(const std::string& appName, int width, int height)
        :Application(appName, width, height)
    {
        LogInfo("Beginning initialization of user created components");
        InitComponent(Paddle);
        InitComponent(BallComponent);
        LogInfo("Ending initialization of user created components");

        LogInfo("Beginning initialization of user created systems");
        InitSystem(PaddleControls);
        InitSystem(BallSystem);
        LogInfo("Ending initialzation of user created systems");
    }
    
    unsigned int m_framerate = 60;

    void Main() override
    {
        double curr_time = glfwGetTime();
        double prev_time = glfwGetTime();
        double deltatime = 0;

        Coordinator* cd = Coordinator::Get();

        LoadScene("res/pong.rscene");

        while (!glfwWindowShouldClose(m_window))
        {
            glEnable(GL_BLEND);
            glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); 

            curr_time = glfwGetTime();
            deltatime = curr_time - prev_time;

            double fps = (double)1 / deltatime;

            cd->GetSystem<CollisionSystem>()->Do();

            cd->GetSystem<PaddleControls>()->Do(m_window);

            cd->GetSystem<BallSystem>()->Do(deltatime);

            cd->GetSystem<CollisionSystem>()->Clear();

            glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
            glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);

            cd->GetSystem<RenderSpriteSystem>()->Do();

            FontManager* fm = FontManager::Get();
            fm->RenderText("FPS: " + std::to_string((int)fps), "Noto Sans", 100, 0.0, 70.0);

            glfwPollEvents();
            glfwSwapBuffers(m_window);

            double timediff = glfwGetTime() - curr_time;
            double calculation = std::max((double)(1.0 / m_framerate) - timediff, 0.0);
            usleep((int)(calculation * 1000000.0));

            prev_time = curr_time;
        }
    }
};


namespace Rocket {
    Application* CreateApplication(const std::string& name, int width, int height)
    {
        return new RocApplication(name, width, height);
    }
}