using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;
using Doji.AI.Depth;

public class ProcessFace : MonoBehaviour
{


    [SerializeField]
    Material faceProcessingMaterial;
    [SerializeField]
    Material blurMaterial;

    Texture2D ingestedTexture = null;
    string fileName = "";
    string[] arguments;

    // Options - Default is Native Png Regular
    EncodeFormat encodeFormat = EncodeFormat.png;

    enum EncodeFormat { png, jpeg, tga };


    void Start()

    {

        faceProcessingMaterial = new Material(Shader.Find("FaceProcessing"));
        //    blurMaterial = new Material(Shader.Find("Blur"));

        StartCoroutine(FetchTexture());

        Invoke("Exit", 10f);
    }

    IEnumerator FetchTexture()
    {

        arguments = System.Environment.GetCommandLineArgs();

        // Ingest texture file as a texture2D - foreaches aren't always sorted so we do this once
        foreach (string argument in arguments)
        {

            // debugText.text += argument + System.Environment.NewLine;

            if (argument.EndsWith(".png") || argument.EndsWith(".jpg") || argument.EndsWith(".jpeg"))
            {
                using (UnityWebRequest uwr = UnityWebRequestTexture.GetTexture("file://" + argument))
                {
                    yield return uwr.SendWebRequest();

                    if (uwr.result == UnityWebRequest.Result.Success)
                    {
                        ingestedTexture = DownloadHandlerTexture.GetContent(uwr);

                        string[] splitFilename = argument.Split(new string[] { "\\", ".", "_" }, System.StringSplitOptions.RemoveEmptyEntries);
                        fileName = "processed_" + splitFilename[splitFilename.Length - 2];

                    }
                }

            }
        }
        Process();
    }



    void Process()
    {

        if (ingestedTexture == null)
        {
            // This isn't actually a texture? Early exit.
            Exit();

        }

        int importedTextureSize = ingestedTexture.height;

        foreach (string argument in arguments)
        {

            //      Killed export format stubs

            // Format

            if (argument.Contains("encodetga"))
            {
                encodeFormat = EncodeFormat.tga;
            }

        }

        using (Midas midas = new())
        {
            midas.NormalizeDepth = true;
            midas.ModelType = ModelType.dpt_beit_large_384;
            midas.EstimateDepth(ingestedTexture);
            RenderTexture predictedDepthTexture = midas.Result;


            Shader.SetGlobalTexture("_RGBFace", ingestedTexture);

            RenderTexture multiChannelDepthTexture = new(importedTextureSize, importedTextureSize, 0, RenderTextureFormat.ARGB32);
            RenderTexture finalTexture = new(importedTextureSize, importedTextureSize, 0, RenderTextureFormat.ARGB32);
            Graphics.Blit(predictedDepthTexture, multiChannelDepthTexture, faceProcessingMaterial);
            Graphics.Blit(multiChannelDepthTexture, finalTexture, blurMaterial);


            // We write the render texture to our output Texture2d
            Texture2D outputTexture = new(importedTextureSize, importedTextureSize, TextureFormat.ARGB32, false, false);
            Rect region = new(0, 0, importedTextureSize, importedTextureSize);
            outputTexture.ReadPixels(region, 0, 0, false);
            outputTexture.Apply();

            //  ouput the file to the target destination
            string desktopPath = System.Environment.GetFolderPath(System.Environment.SpecialFolder.Desktop);

            if (encodeFormat == EncodeFormat.tga)
            {
                System.IO.File.WriteAllBytes(System.Environment.CurrentDirectory + "/" + fileName + ".tga", outputTexture.EncodeToTGA());
            }
            else
            {
                System.IO.File.WriteAllBytes(System.Environment.CurrentDirectory + "/" + fileName + ".png", outputTexture.EncodeToPNG());
            }



            Exit();

        }

        /*

        // Okay cool, we attached to a texture. Let's initialize a render texture the same size
        int superSampledTextureSize = targetTextureSize * 2;
        //      RenderTexture normalizedRenderTexture = new(superSampledTextureSize, superSampledTextureSize, 0, RenderTextureFormat.ARGB32);
         //     RenderTexture blurredRenderTexture = new(targetTextureSize, targetTextureSize, 0, RenderTextureFormat.ARGB32);

        // We blit the render texture onto our material to compute the normal map
        
     //   Graphics.Blit(ingestedTexture, normalizedRenderTexture, normalizeMaterial);
        //    Graphics.Blit(normalizedRenderTexture, blurredRenderTexture, blurMaterial);

        // We write the render texture to our output Texture2d
        Texture2D outputTexture = new(targetTextureSize, targetTextureSize, TextureFormat.ARGB32, false, false);
        Rect region = new(0, 0, targetTextureSize, targetTextureSize);
        outputTexture.ReadPixels(region, 0, 0, false);
        outputTexture.Apply();

        //  ouput the file to the target destination
        string desktopPath = System.Environment.GetFolderPath(System.Environment.SpecialFolder.Desktop);

        if (encodeFormat == EncodeFormat.png)
        {
            System.IO.File.WriteAllBytes(System.Environment.CurrentDirectory + "/" + fileName + ".png", outputTexture.EncodeToPNG());
        }
        if (encodeFormat == EncodeFormat.jpeg)
        {
            System.IO.File.WriteAllBytes(System.Environment.CurrentDirectory + "/" + fileName + ".jpeg", outputTexture.EncodeToPNG());
        }
        if (encodeFormat == EncodeFormat.tga)
        {
            System.IO.File.WriteAllBytes(System.Environment.CurrentDirectory + "/" + fileName + ".tga", outputTexture.EncodeToPNG());
        }



        Exit();*/
        //    }
    }

    void Exit()
    {
        Application.Quit();
    }
}
