repos:
-   repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v2.3.0
    hooks:
    -   id: check-yaml
    -   id: end-of-file-fixer
    -   id: trailing-whitespace
- repo: https://github.com/gruntwork-io/pre-commit
  rev: v0.1.17
  hooks:
    - id: tflint
      args:
        - "--module"
        - "--config=.tflint.hcl"
    - id: terraform-validate
    - id: terraform-fmt
- repo: https://github.com/antonbabenko/pre-commit-terraform
  rev: v1.76.0
  hooks:
    - id: terraform_tfsec
    - id: terraform_docs
      args:
      - --hook-config=--path-to-file=README.md
      - --hook-config=--add-to-existing-file=true
      - --hook-config=--create-file-if-not-exist=true
    - id: terraform_checkov
      args:
        - --args=--skip-path .github
