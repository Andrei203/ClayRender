using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class rotatesc : MonoBehaviour
{
   [SerializeField] private Vector3 cubeRotate;
   [SerializeField] private float rotateSpeed;

    void Update()
   {
        transform.Rotate(cubeRotate * rotateSpeed * Time.deltaTime);  
   }
}

