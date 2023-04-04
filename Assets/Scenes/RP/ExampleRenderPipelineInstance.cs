using System;
using UnityEngine;
using UnityEngine.Rendering;

public class ExampleRenderPipelineInstance : RenderPipeline
{
    // 使用此变量来引用传递给构造函数的渲染管线资源
    private ExampleRenderPipelineAsset renderPipelineAsset;

    // 构造函数将 ExampleRenderPipelineAsset 类的实例作为其参数。
    public ExampleRenderPipelineInstance(ExampleRenderPipelineAsset asset)
    {
        renderPipelineAsset = asset;
    }

    // 对于当前正在渲染的每个 CameraType，Unity 每帧调用一次此方法。
    protected override void Render(ScriptableRenderContext context, Camera[] cameras)
    {
        BeginFrameRendering(context, cameras);

        //这是使用渲染管线资源数据的示例。
        //Debug.Log(renderPipelineAsset.exampleString);
        foreach(Camera camera in cameras)
        {
            Debug.Log(camera.name);
            if (IsGameCamera(camera))
            {
                //RenderCameraStack(renderContext, camera);
                
                BeginCameraRendering(context, camera);
                //RenderSingleCamera(context, camera);

                        
                // 可以在此处编写自定义渲染代码。通过自定义此方法可以自定义 SRP。
                var cmd = new CommandBuffer();
                cmd.name = "MainCamera";
                cmd.ClearRenderTarget(true, true, renderPipelineAsset.exampleColor);
                context.ExecuteCommandBuffer(cmd);
                cmd.Release();
        
                 // 指示可编程渲染上下文告诉图形 API 执行调度的命令
                context.Submit();

                EndCameraRendering(context, camera);
            }
            else
            {
                BeginCameraRendering(context, camera);
                //RenderSingleCamera(context, camera);

                        
                // 可以在此处编写自定义渲染代码。通过自定义此方法可以自定义 SRP。
                var cmd = new CommandBuffer();
                cmd.name = "MainCamera";
                cmd.ClearRenderTarget(true, true, renderPipelineAsset.exampleColor);
                context.ExecuteCommandBuffer(cmd);
                cmd.Release();

                 // 指示可编程渲染上下文告诉图形 API 执行调度的命令
                context.Submit();

                EndCameraRendering(context, camera);
            }
        }


        EndFrameRendering(context, cameras);
    }

    public static bool IsGameCamera(Camera camera)
    {
        if (camera == null)
            throw new ArgumentNullException("camera");

        return camera.cameraType == CameraType.Game || camera.cameraType == CameraType.VR;
    }
}