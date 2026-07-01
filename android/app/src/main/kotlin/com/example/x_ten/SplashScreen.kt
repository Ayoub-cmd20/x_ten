package com.example.x_ten

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

@Composable
fun SplashScreen(modifier: Modifier = Modifier) {
    Box(
        modifier = modifier
            .fillMaxSize()
            .background(Color(0xFF0A0A0A)),
        contentAlignment = Alignment.Center
    ) {
        // Central Logo and Text
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            // Logo Container with Glow Effect
            Box(
                contentAlignment = Alignment.Center
            ) {
                // Glow
                Box(
                    modifier = Modifier
                        .size(180.dp)
                        .background(
                            brush = Brush.radialGradient(
                                colors = listOf(Color(0xFFD4AF37).copy(alpha = 0.15f), Color.Transparent),
                                radius = 350f
                            )
                        )
                )

                // Rounded Box
                Box(
                    modifier = Modifier
                        .size(120.dp)
                        .clip(RoundedCornerShape(32.dp))
                        .background(
                            brush = Brush.verticalGradient(
                                colors = listOf(Color(0xFF2C2C2C), Color(0xFF1A1A1A))
                            )
                        ),
                    contentAlignment = Alignment.Center
                ) {
                    DiamondIcon(
                        modifier = Modifier.size(50.dp),
                        color = Color(0xFFD4AF37)
                    )
                }
            }

            Spacer(modifier = Modifier.height(48.dp))

            // Arabic Title
            Text(
                text = stringResource(id = R.string.splash_title_arabic),
                color = Color(0xFFD4AF37),
                fontSize = 40.sp,
                fontWeight = FontWeight.Bold
            )

            Spacer(modifier = Modifier.height(8.dp))

            // English Title
            Text(
                text = stringResource(id = R.string.splash_title_english),
                color = Color(0xFF8E8E93),
                fontSize = 14.sp,
                letterSpacing = 4.sp,
                fontWeight = FontWeight.Medium
            )
        }

        // Bottom Content
        Column(
            modifier = Modifier
                .align(Alignment.BottomCenter)
                .padding(bottom = 60.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            // Progress Bar
            Box(
                modifier = Modifier
                    .width(140.dp)
                    .height(2.dp)
                    .background(Color(0xFF1C1C1E))
            ) {
                Box(
                    modifier = Modifier
                        .fillMaxWidth(0.6f)
                        .fillMaxHeight()
                        .background(Color(0xFFD4AF37))
                )
            }

            Spacer(modifier = Modifier.height(24.dp))

            // Version Info
            Text(
                text = stringResource(id = R.string.version_info),
                color = Color(0xFF48484A),
                fontSize = 11.sp,
                letterSpacing = 1.sp
            )
        }
    }
}

@Composable
fun DiamondIcon(modifier: Modifier = Modifier, color: Color = Color.White) {
    Canvas(modifier = modifier) {
        val w = size.width
        val h = size.height
        
        // Bottom large triangle
        val bottomTriangle = Path().apply {
            moveTo(w * 0.05f, h * 0.38f)
            lineTo(w * 0.95f, h * 0.38f)
            lineTo(w / 2, h)
            close()
        }
        drawPath(bottomTriangle, color = color)
        
        // Top facets (approximating the 4-facet look)
        // Left facet
        drawPath(
            Path().apply {
                moveTo(w * 0.05f, h * 0.38f)
                lineTo(w * 0.25f, 0f)
                lineTo(w * 0.48f, h * 0.38f)
                close()
            },
            color = color
        )
        
        // Right facet
        drawPath(
            Path().apply {
                moveTo(w * 0.95f, h * 0.38f)
                lineTo(w * 0.75f, 0f)
                lineTo(w * 0.52f, h * 0.38f)
                close()
            },
            color = color
        )
        
        // Center facet
        drawPath(
            Path().apply {
                moveTo(w * 0.28f, 0f)
                lineTo(w * 0.72f, 0f)
                lineTo(w / 2, h * 0.35f)
                close()
            },
            color = color
        )
    }
}

@Preview(showBackground = true, backgroundColor = 0xFF0A0A0A)
@Composable
fun SplashScreenPreview() {
    MaterialTheme {
        SplashScreen()
    }
}
