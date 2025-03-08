          ALB_DNS=$(aws elbv2 describe-load-balancers --names nginx-alb --query "LoadBalancers[0].DNSName" --output text --region "$AWS_REGION")
            # 
          # Extract the existing ALB DNS from README.md
          EXISTING_ALB_DNS=$(grep -oP '(?<=Application URL: ).*' README.md || echo "")

          # Compare values
          # If ALB DNS is the same as the existing one, skip the update, to avoid errors.
          if [[ "$ALB_DNS" == "$EXISTING_ALB_DNS" ]]; then
            echo "ALB DNS is already up-to-date. No update needed."
            exit 0  # Skip further execution
          fi

          # Print the first few lines of README to verify changes
          head README.md

          echo "Updating README.md with new ALB DNS..."
          sed -i "s|Application URL: .*|Application URL: http://$ALB_DNS|" README.md

          # Check if there are actual changes
          if git diff --exit-code README.md; then
            echo "No changes detected in README.md. Skipping commit and push."
            exit 0
          fi

          # Configure Git and push the changes
          git config --global user.email "github-actions@github.com"
          git config --global user.name "GitHub Actions"
          git remote set-url origin https://x-access-token:${GITHUB_TOKEN}@github.com/${{ github.repository }}.git

          echo "Adding README.md to Git..."
          git add README.md
          git commit -m "Update ALB DNS in README.md"

          echo "Pushing changes to main branch..."
          git push origin main