## Some useful terraform commands

- `terraform validate`
- `terraform fmt`
- `terraform show`
  - `terraform show -json`
- `terraform output`
  - `terraform output <output_name>`

- `terraform graph`
  - generates a graph representation of terraform dependencies in dot format
  - We can use tool like graphviz to generate graph
    - install graphviz `sudo apt-get install graphviz`
    - `terraform graph | dot -Tsvg > graph.svg`
      - It will generate `graph.svg` file

## Resource and Data Source
| Resource                                |     Data Source                                  |
|-----------------------------------------|:------------------------------------------------:|
| Keyword: `resource`                     | Keyword: `data`
| `Creates`, `Updates`, Destroys Infra-   | Only `Reads` Infrastructure
  structure
| Also called Managed Resources           | Also called `Data Resources`